#!/usr/bin/env bash
set -euxo pipefail

repo_root=$(realpath "$(dirname "$0")/..")
input_parameter_file="${repo_root}/test/force-l2-params-relative.yml"
outdir="${repo_root}/../target/level2"
echo "repo_root: ${repo_root}"

export AWS_ENDPOINT_URL_S3='https://eodata.dataspace.copernicus.eu'
export S3_ENDPOINT_URL="$AWS_ENDPOINT_URL_S3" # for s5cmd

env_message="Please make sure AWS_SECRET_ACCESS_KEY and AWS_ACCESS_KEY_ID are set when running this test (${0})"
docker_image_name="quay.io/bcdev/force-eoap:dev"

set +x # do not log credentials
if [[ -z "$AWS_SECRET_ACCESS_KEY" || -z "$AWS_ACCESS_KEY_ID" ]]; then
  echo "$env_message" >&2
  exit 1
fi
set -x

# Does nothing until overrides are included again
#if [[ "${1:-}" == "docker" ]]; then
#  echo "Building docker container ${docker_image_name}"
#  docker build -t "$docker_image_name" "$repo_root"
#else echo "Reusing docker image ${docker_image_name}. Pass 'docker' as an argument to rebuild it"
#fi

# TODO add overrides back on for local tests (or make a parameter)
#--overrides "${repo_root}/test/local-overrides.yaml" \
cwltool \
  --preserve-environment=AWS_ENDPOINT_URL_S3 \
  --preserve-environment=S3_ENDPOINT_URL \
  --preserve-environment=AWS_ACCESS_KEY_ID \
  --preserve-environment=AWS_SECRET_ACCESS_KEY \
  --debug \
  --outdir="$outdir"\
  --tmpdir-prefix="${HOME}/tmp" \
  "${repo_root}/cwl/force-l2.cwl" \
  "$input_parameter_file"


# check that asset links can be found
cd "$outdir/l2-ard" # must check relative paths in the assets from outdir
pwd
missing=0
find . -name 'cube-*.json' -print0 |
    xargs -0 jq -r '
  .assets // {} | to_entries[].value.href
  ' | while read -r f; do
        [[ -e "$f" ]] || {
          echo "Missing asset: $f (tested $(realpath $f))"
          missing=1
        }
done
exit $missing