#! /bin/env bash

set -euxo pipefail

pyproject_version=$(grep "version" python/pyproject.toml | sed -E 's/version = "(.*)"/\1/' | tr -d '\n')
docker_requirement_version=$(sed -E 's#quay.io/bcdev/force-eoap:##' cwl/docker-requirement.yaml | tr -d '\n')

if [[ "$pyproject_version" == "$docker_requirement_version" ]]; then
    echo "Versions match"
else
    echo "Versions do not match: [$pyproject_version] (pyproject.toml) and [$docker_requirement_version] (cwl/docker_requirement.yaml) " &1>2
    exit 1
fi


