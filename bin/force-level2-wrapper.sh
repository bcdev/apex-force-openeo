#!/bin/bash
set -e
set -x

# This shell script is called as an entry point into the FORCE wrapper Docker container.
# Parameters are passed as --key value arguments.
# Inputs are passed as path to a directory with .SAFE subdirectories.
# The tmp directory shall be used for all intermediates.
# The working directory shall be used for the output.
# Environment variables AWS_ENDPOINT_URL_S3, AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY are provided by the caller

# trace
grep MemTotal /proc/meminfo
set +e; cat /sys/fs/cgroup/memory.max; set -e

# parse parameter and replace defaults in env

export inputs=
export aoi=NULL
export resolution=10
export projection=GLANCE7
export resampling=CC
export tile_size=30000
export block_size=3000
export origin_lon=-25
export origin_lat=60
export dem=NULL
export do_atmo=FALSE
export do_topo=FALSE
export do_brdf=FALSE
export do_adjacency=FALSE
export do_multi_scattering=FALSE
export do_aod=FALSE
export erase_clouds=FALSE
export max_cloud_cover_frame=99
export max_cloud_cover_tile=99
export cloud_buffer=300
export cirrus_buffer=0
export shadow_buffer=90
export snow_buffer=30
export cloud_threshold=0.225
export shadow_threshold=0.02
export res_merge=IMPROPHE
export impulse_noise=FALSE
export buffer_nodata=FALSE
export nproc=1
export nthread=4
export parallel_reads=FALSE
export process_start_delay=3
export timeout_zip=300
export output_format=GTiff
export output_dst=FALSE
export output_aod=FALSE
export output_wvp=FALSE
export output_vzn=FALSE
export output_hot=FALSE
export output_ovv=TRUE

while [ "$1" != "" ]; do
    if [ "${1:0:2}" = "--" -a "${2:0:2}" = "--" ]; then
        declare ${1:2}="TRUE"
        export ${1:2}
        shift 1
    elif [ "${1:0:2}" = "--" ]; then
        declare ${1:2}="$2"
        export ${1:2}
        shift 2
    else
        echo unexpected positional parameter $1. Inputs shall be passed as directory in parameter --inputs.
        exit 1
    fi
done

export do_atmo="${do_atmo^^}"
export do_topo="${do_topo^^}"
export do_brdf="${do_brdf^^}"
export do_adjacency="${do_adjacency^^}"
export do_multi_scattering="${do_multi_scattering^^}"
export do_aod="${do_aod^^}"
export erase_clouds="${erase_clouds^^}"
export impulse_noise="${impulse_noise^^}"
export buffer_nodata="${buffer_nodata^^}"
export output_dst="${output_dst^^}"
export output_aod="${output_aod^^}"
export output_wvp="${output_wvp^^}"
export output_vzn="${output_vzn^^}"
export output_hot="${output_hot^^}"
export output_ovv="${output_ovv^^}"

default_name=cube-$(date -u +%Y%m%dT%H%M%S)
export processing_name=${name:-$default_name}

# trace
find "$inputs"

# use working directory for outputs
# use /tmp for all intermediates

rm -f /tmp/outputs
ln -s $(pwd) /tmp/outputs
cd /tmp

# convert AOI geojson into shapefile

uv() {
  /opt/uv/uv "$@"
}
aoi-converter() {
  uv run --project /opt/force-python-tools --no-sync --no-cache force-aoi-converter "$@"
}

if [ "$aoi" != NULL ]; then
    aoi-converter "$aoi" aoi.shp
    if [ ! -e aoi.shp ]; then
        echo "ERROR: conversion of AOI $aoi to shapefile failed"
        exit 1
    fi
    export aoi=/tmp/aoi.shp
fi

# list inputs in FORCE queue

mkdir inputs
rm -f inputs/tds.txt
touch inputs/tds.txt

for safe_archive in "$inputs"/*/; do
    # S2A_MSIL1C_20241113T101251_N0511_R022_T32TPQ_20241113T121135.SAFE
    if [[ "$(basename $safe_archive)" != S2*SAFE ]]; then
        echo "ERROR: unexpected directory name $safe_archive . Expected .../S2*SAFE ."
        exit 1
    fi
    echo "$(realpath "$safe_archive") QUEUED" >> inputs/tds.txt
done

# trace
cat inputs/tds.txt

if [ $(cat inputs/tds.txt|wc -l) == 0 ]; then
    echo "ERROR: no inputs provided in $inputs"
    exit 1
fi

# retrieve DEM unless available
# structure is
#   required vrt goes to /tmp/mgrs-vrt/...
#   downloaded tiles go to /tmp/copernicus/...
# only Copernicus DEM 30m is supported

if [[ "$dem" == "" || "$dem" == "NULL" || "$dem" == "NONE" ]]; then
    if [ "$do_topo" = "TRUE" ]; then
        echo "ERROR: do_topo set to TRUE but dem not set"
        exit 1
    fi
    export file_dem=NULL
    export dem_database=NULL
elif [ "$dem" == "Copernicus_30m" ]; then
    s5cmd_command_file="/tmp/s5cmd_commands.txt"
    touch "$s5cmd_command_file"
    mkdir -p /tmp/copernicus /tmp/mgrs-vrt
    for safe_archive in "$inputs"/*/; do
        granule_filename=$(basename "$safe_archive")
        granule=${granule_filename:39:5}
        vrt_path=/opt/apex-force-wrapper/auxdata/MGRS_VRT/MGRS_T${granule}.vrt
        cp "$vrt_path" /tmp/mgrs-vrt/
        for dem_tile_path in $(xmlstarlet sel -t -v /VRTDataset/VRTRasterBand/ComplexSource/SourceFilename $vrt_path); do
            dem_tile_name=$(basename "$dem_tile_path")
            eodata_tile_path=$(ls -l "/opt/apex-force-wrapper/auxdata/copernicus/${dem_tile_name}" | awk '{print $11}')
            s5cmd_string="cp s3:/${eodata_tile_path} /tmp/copernicus/"
            if grep -q "$s5cmd_string" "$s5cmd_command_file"; then
                echo "$dem_tile_name already scheduled for download"
            else
                echo "$s5cmd_string" >> "$s5cmd_command_file"
            fi
        done
    done
    if [[ "$(wc -l < $s5cmd_command_file)" -gt 0 ]]; then
        if [ -z "${AWS_ACCESS_KEY_ID-}" -o -z ${AWS_SECRET_ACCESS_KEY-} ]; then
            echo "ERROR: missing env vars AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY"
            exit 1
        fi
        if [ -z "${AWS_ENDPOINT_URL_S3-}" ]; then
            export AWS_ENDPOINT_URL_S3='https://eodata.dataspace.copernicus.eu'
	    echo "Environmental variables AWS_ENDPOINT_URL_S3 not defined. Using default: $AWS_ENDPOINT_URL_S3"
        fi
        # for s5cmd:
        export S3_ENDPOINT_URL=$AWS_ENDPOINT_URL_S3

        echo "Running s5cmd commands file"
        cat "$s5cmd_command_file"
        s5cmd run "$s5cmd_command_file"
    else
        echo "no dem tiles to download"
    fi
    find /tmp/mgrs-vrt
    find /tmp/copernicus
    export file_dem=/tmp/mgrs-vrt
    export use_dem_database=TRUE
    if [ "$do_topo" = "FALSE" ]; then
        echo "WARNING: dem set but do_topo is false"
    fi
else
    echo ERROR: DEM other than Copernicus_30m not yet supported, but dem=$dem set as parameter
    exit 1
fi

# create parameter file

mkdir -p param
envsubst < /opt/apex-force-wrapper/etc/force-level2-parameters.template > param/l2ps.prm

#trace
cat param/l2ps.prm

# call force-level2

mkdir -p outputs/l2-ard log provenance temp

# docker run -i -t -v `pwd`:/data -w /data --user "$(id -u):$(id -g)" --rm davidfrantz/force bash -c "force-level2 param/l2ps.prm"
script -q -e /dev/stdout -c "force-level2 param/l2ps.prm"

# debug
find outputs

if [ ! -e outputs/l2-ard ]; then
    echo "ERROR: no output directory found"
    exit 1
fi
if ! ls outputs/l2-ard/*/datacube-definition.prj > /dev/null 2>&1; then
    echo "ERROR: output does not contain a datacube definition"
    exit 1
fi
if ! ls outputs/l2-ard/*/X*_Y* > /dev/null 2>&1; then
    echo "ERROR: output does not contain any tile"
    exit 1
fi

rm -rf outputs/.parallel

# create stac catalogue for output

uv() {
  /opt/uv/uv "$@"
}
gen-stac() {
  uv run --project /opt/force-python-tools --no-sync gen-stac "$@"
}

# TODO instead of hardcoded europe, generate stac for each continent
mv outputs/l2-ard/CITEME* outputs/l2-ard/europe/

gen-stac outputs/l2-ard/europe --output-path outputs/l2-ard/europe --item-id "$processing_name-level2" --type level2
