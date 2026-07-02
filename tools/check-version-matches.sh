#! /bin/env bash

set -euxo pipefail

pyproject_version=$(grep "version" python/pyproject.toml | sed -E 's/version = "(.*)"/\1/' | tr -d '\n')
docker_requirement_version=$(sed -E 's#quay.io/bcdev/force-eoap:##' cwl/docker-requirement.yaml | tr -d '\n')
reference=${1:-$docker_requirement_version}
reference=$(echo "$reference" | tr -d '\n')

if [[ "$pyproject_version" != "$docker_requirement_version" ]]; then
    echo "Versions do not match: [$pyproject_version] (pyproject.toml) and [$docker_requirement_version] (cwl/docker_requirement.yaml) " &1>2
    exit 1
fi

if [[ "$pyproject_version" != "$reference" ]]; then
    echo "Versions do not match: [$pyproject_version] (pyproject.toml) and [$reference] (reference) " &1>2
    exit 1
fi




