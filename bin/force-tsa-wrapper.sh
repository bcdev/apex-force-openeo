#!/bin/env bash
set -e
set -x

# parse parameter and replace defaults in env
# list parameters are passed as comma-separated values: MIN,MAX,Q50

export input_data_dir=
export time_range=
export doy_range=1,366
export x_tile_range=-999,9999
export y_tile_range=-999,9999
export file_tile=NULL
export chunk_size=7500,7500
export resolution=20
export use_l2_improphe=false
export sensors=SEN2A,SEN2B,SEN2C
export target_sensors=SEN2L
export product_type_main=BOA
export product_type_quality=QAI
export spectral_adjust=false
export screen_qai=NODATA,CLOUD_OPAQUE,CLOUD_BUFFER,CLOUD_CIRRUS,CLOUD_SHADOW,SNOW,SUBZERO,SATURATION
export above_noise=0
export below_noise=0
export index=NULL
export standardize_tss=NONE
export output_tss=false
export interpolate=NONE
export moving_max=16
export rbf_sigma=8,16,32
export rbf_cutoff=0.95
export harmonic_trend=false
export harmonic_modes=3
export harmonic_fit_range=
export output_nrt=false
export int_days=16
export standardize_tsi=NONE
export output_tsi=false
export output_stm=false
export stm=
export fold_type=AVG
export output_fby=false
export output_fbq=false
export output_fbm=false
export output_fbw=false
export output_fbd=false
export output_try=false
export output_trq=false
export output_trm=false
export output_trw=false
export output_trd=false
export output_cay=false
export output_caq=false
export output_cam=false
export output_caw=false
export output_cad=false
export pol_start_threshold=0.2
export pol_mid_threshold=0.5
export pol_end_threshold=0.8
export pol_adaptive=false
export pol=
export standardize_pol=NONE
export output_pct=false
export output_pol=false
export output_tro=false
export output_cao=false
export trend_tail=TWO
export trend_conf=0.95
export change_penalty=false
export output_format=GTiff
export output_explode=false
export fail_if_empty=false

ERROR_INCORRECT_INPUT=3

while [ "$1" != "" ]; do
    if [ "${1:0:2}" = "--" ]; then
        declare ${1:2}="${2//,/ }"
        export ${1:2}
        shift 2
      else
        exit $ERROR_INCORRECT_INPUT
    fi
done

if [ "$time_range" = "" ]; then
    echo "missing time_range"
    exit 4
elfi [ "$dir_input_data" = "" ]; then
    echo "missing dir_input_data"
    exit 4
fi

export use_l2_improphe=${use_l2_improphe^^}
export spectral_adjust=${spectral_adjust^^}
export output_tss=${output_tss^^}
export harmonic_trend=${harmonic_trend^^}
export output_nrt=${output_nrt^^}
export output_tsi=${output_tsi^^}
export output_stm=${output_stm^^}
export output_fby=${output_fby^^}
export output_fbq=${output_fbq^^}
export output_fbm=${output_fbm^^}
export output_fbw=${output_fbw^^}
export output_fbd=${output_fbd^^}
export output_try=${output_try^^}
export output_trq=${output_trq^^}
export output_trm=${output_trm^^}
export output_trw=${output_trw^^}
export output_trd=${output_trd^^}
export output_cay=${output_cay^^}
export output_caq=${output_caq^^}
export output_cam=${output_cam^^}
export output_caw=${output_caw^^}
export output_cad=${output_cad^^}
export pol_adaptive=${pol_adaptive^^}
export output_pct=${output_pct^^}
export output_pol=${output_pol^^}
export output_tro=${output_tro^^}
export output_cao=${output_cao^^}
export change_penalty=${change_penalty^^}
export output_explode=${output_explode^^}
export fail_if_empty=${fail_if_empty^^}

export output_dir="outputs/hlps-tsa"
export provenance_dir="outputs/provenance"

parameter_template="/opt/apex-force-wrapper/etc/force-tsa-parameters.template"
filled_parameter_path="param/force-tsa-parameters.prm"

mkdir -p $(dirname "$filled_parameter_path")
mkdir -p $output_dir
mkdir -p $provenance_dir

envsubst < "$parameter_template" > "$filled_parameter_path"

exit_code=$?
if [ ! -e "${output_dir}"/CITEME* ]; then
    script -q -e /dev/stdout -c "force-higher-level ${filled_parameter_path}"
    exit_code=$?
fi

exit $exit_code

# TODO create stac catalog for outputs