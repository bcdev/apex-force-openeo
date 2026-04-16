#!/usr/bin/env bash
set -euxo pipefail
repo_root=$(realpath "$(dirname "$0")/..")
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

if [[ "${1:-}" == "docker" ]]; then
  echo "Building docker container ${docker_image_name}"
  docker build -t "$docker_image_name" "$repo_root"
else
  echo "Reusing docker image ${docker_image_name}. Pass 'docker' as an argument to rebuild it"
fi

cwltool \
  --preserve-environment=AWS_ENDPOINT_URL_S3 \
  --preserve-environment=S3_ENDPOINT_URL \
  --preserve-environment=AWS_ACCESS_KEY_ID \
  --preserve-environment=AWS_SECRET_ACCESS_KEY \
  --outdir="${repo_root}/../target/level2" \
  --tmpdir-prefix="${HOME}/tmp" \
  --overrides "${repo_root}/test/local-overrides.yaml" \
  "${repo_root}/cwl/force-l2.cwl" \
  "${repo_root}/test/force-l2-params-reduced-number-of-items.yml"
