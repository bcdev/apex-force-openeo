#!/bin/env bash
set -e
set -x


ERROR_INCORRECT_INPUT=3

# shorthands

uv() {
  /opt/uv/uv "$@"
}
gen-stac() {
  uv run --project /opt/force-python-tools --no-sync gen-stac "$@"
}

# list parameters are passed as comma-separated values: MIN,MAX,Q50

while [ "$1" != "" ]; do
    if [ "${1:0:2}" = "--" ]; then
        declare ${1:2}="${2//,/ }"
        export ${1:2}
        shift 2
      else
        exit $ERROR_INCORRECT_INPUT
    fi
done


parameter_template="/opt/apex-force-wrapper/etc/force-tsa-parameters.template"
filled_parameter_path="param/force-tsa-parameters.prm"
output_dir="outputs/hlps-tsa"
provenance_dir="outputs/provenance"
stac_output_dir="outputs/stac"

mkdir -p param
envsubst < "$parameter_template" > "$filled_parameter_path"

mkdir -p "$output_dir"
mkdir -p "$provenance_dir"
mkdir -p "$stac_output_dir"

exit_code=$?
if [ ! -e "${output_dir}"/CITEME* ]; then
    script -q -e /dev/stdout -c "force-higher-level ${filled_parameter_path}"
    exit_code=$?
fi

if [[  "$exit_code" != 0 ]]; then
  exit $exit_code
fi

# create stac catalog for outputs

gen-stac "$output_dir" --output-path "$stac_output_dir" --id-prefix ""

exit $?