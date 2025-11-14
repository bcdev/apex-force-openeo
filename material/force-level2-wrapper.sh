#!/bin/bash
set -e
#set -x

# This shell script is called as an entry point into the FORCE wrapper Docker container.
# Parameters and the catalogue of inputs are passed as command line arguments with --key value syntax.
# the last parameter is the catalogue.json with the URLs of inputs.

mkdir -p inputs
rm -f inputs/tds.txt
touch inputs/tds.txt

# catalogue.json
catalogue=${@:$#}
# ./S2A_MSIL1C_20241113T101251_N0511_R022_T32TPQ_20241113T121135.SAFE.json
for item in $(cat $catalogue|jq -r .links[].href); do
    # s3://eodata/Sentinel-2/MSI/L1C/2024/11/13/S2A_MSIL1C_20241113T101251_N0511_R022_T32TPQ_20241113T121135.SAFE
    safeurl=$(cat $item | jq -r .assets.product_metadata.href|xargs -n 1 dirname)
    if [ ! -e inputs/$(basename $safeurl) ]; then
        echo staging $(basename $safeurl)
        s3cmd -c ~/dot-s3cfg-cdsedata get -r $safeurl inputs
    else
        echo $(basename $safeurl) already available
    fi
    echo /data/inputs/$(basename $safeurl) QUEUED >> inputs/tds.txt
done

mkdir -p param outputs

export aoi=NULL
export resolution=10
export projection=GLANCE7
export resampling=CC
export origin_lon=-25
export origin_lat=60
export dem=NULL
export do_atmo=TRUE
export do_topo=FALSE
export do_brdf=TRUE
export do_adjacency=TRUE
export do_multi_scattering=TRUE
export do_aod=TRUE
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
export impulse_noise=TRUE
export buffer_nodata=FALSE
export nproc=3
export nthread=4
export parallel_reads=FALSE
export process_start_delay=3
export timeout_zip=30
export output_format=GTiff
export output_dst=FALSE
export output_aod=FALSE
export output_wvp=FALSE
export output_vzn=FALSE
export output_hot=FALSE
export output_ovv=TRUE

# parse parameter and replace defaults in env here

cat l2ps.template | envsubst > param/l2ps.prm

mkdir -p log provenance temp

# preliminary call of force-level2 via docker, will later call force-level2 directly and the wrapper script runs in the container

# docker run -v `pwd`:/data -w /data --user "$(id -u):$(id -g)" davidfrantz/force bash -c "force-level2 param/l2ps.prm > l2.out 2>&1"
docker run -i -t -v `pwd`:/data -w /data --user "$(id -u):$(id -g)" --rm davidfrantz/force bash -c "force-level2 param/l2ps.prm"
