#!/usr/bin/env bash
set -euxo pipefail
repo_root=$(realpath "$(dirname "$0")/..")
input_parameter_file="${repo_root}/test/force-tsa/force-tsa-params-relative.yml"
outdir="${repo_root}/../target/tsa"
echo "repo_root: ${repo_root}"

export AWS_ENDPOINT_URL_S3='https://eodata.dataspace.copernicus.eu'
export S3_ENDPOINT_URL="$AWS_ENDPOINT_URL_S3" # for s5cmd

env_message="Please make sure AWS_SECRET_ACCESS_KEY and AWS_ACCESS_KEY_ID are set when running this test (${0})"
docker_image_name="quay.io/bcdev/force-eoap:dev"

if [[ "${1:-}" == "docker" ]]; then
  echo "Building docker container ${docker_image_name}"
  docker build -t "$docker_image_name" "$repo_root"
else echo "Reusing docker image ${docker_image_name}. Pass 'docker' as an argument to rebuild it"
fi

# TODO add back in
# --overrides "${repo_root}/test/local-overrides.yaml" \
cwltool \
  --outdir="$outdir" \
  --tmpdir-prefix="${HOME}/tmp" \
  "${repo_root}/cwl/force-tsa.cwl" \
  "$input_parameter_file"

# check that asset links can be found
cd "$outdir/force-tsa" # must check relative paths in the assets from outdir
pwd
missing=0
find . -name '*tsa.json' -print0 |
    xargs -0 jq -r '
  .assets // {} | to_entries[].value.href
  ' | while read -r f; do
        [[ -e "$f" ]] || {
          echo "Missing asset: $f (tested $(realpath $f))"
          missing=1
        }
done
exit $missing
