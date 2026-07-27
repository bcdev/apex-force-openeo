#! /bin/env bash

set -euxo pipefail

sed_extract_version='s/version = "(.*)"/\1/'

pyproject_version=$(grep "version" python/pyproject.toml | sed -E "$sed_extract_version" | tr -d '\n')
docker_requirement_version=$(sed -E 's#quay.io/bcdev/force-eoap:##' cwl/docker-requirement.yaml | tr -d '\n')
pixi_version="NO_VERSION"
if command -v pixi >/dev/null 2>&1; then
    pixi_version=$(pixi workspace version get | tr -d '\n')
elif command -v tomlq >/dev/null 2>&1; then
    pixi_version=$(tomlq ".workspace.version" pixi.toml | tr -d '\n"')
else
    echo "Pixi or tomlq must be installed to determine the pixi version" 1>&2
fi

pixi_version=$(grep "^version = " pixi.toml | sed -E "$sed_extract_version")

reference=${1:-$docker_requirement_version}
reference=$(echo "$reference" | tr -d '\n')

echo "reference is: $reference"

if [[ "$docker_requirement_version" != "$reference" ]]; then
    echo "Versions do not match: [$docker_requirement_version] (cwl/docker-requirement.yaml) and [$reference] (reference) " 1>&2
    exit 1
fi

if [[ "$pyproject_version" != "$reference" ]]; then
    echo "Versions do not match: [$pyproject_version] (python/pyproject.toml) and [$reference] (reference) " 1>&2
    exit 1
fi


if [[ "$pixi_version" != "$reference" ]]; then
    echo "Versions do not match: ["$pixi_version"] (pixi.toml) and [$reference] (reference)" 1>&2
    exit 1
fi

echo "All versions match the reference $reference"
