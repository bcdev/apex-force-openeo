#!/usr/bin/env bash

set -euxo pipefail

repo_root=$(realpath "$(dirname "$0")/..")
out=${1:-${repo_root}/target}
visualize=${2:-}

if [[ ! $(which cwltool) ]]; then
  echo "Make sure cwltool is installed to run this tool"
  exit 1
fi

mkdir -p "$out"
cwltool --pack "${repo_root}/cwl/force-l2-workflow.cwl" > "${out}/force-level2.cwl"
cwltool --pack "${repo_root}/cwl/force-tsa-workflow.cwl" > "${out}/force-tsa.cwl"

if [[ -n "$visualize" ]]; then
  if [[ ! $(which dot) ]]; then
    echo "Make sure dot is installed to visualize"
    exit 1
  fi
  mkdir "${out}/img"
  cwltool --print-dot "${out}/force-level2.cwl" | dot -Tsvg > "${out}/img/force-level2.svg"
  cwltool --print-dot "${out}/force-tsa.cwl" | dot -Tsvg > "${out}/img/force-tsa.svg"
fi