cwlVersion: v1.2

class: CommandLineTool
requirements:
  NetworkAccess:
    networkAccess: true
  DockerRequirement:
    dockerPull:
      $include: docker-requirement.yaml

baseCommand: /opt/uv/uv
arguments:
  - "run"
  - "--no-sync"        # use locked python environment from container
  - "--project"
  - "/opt/force-python-tools"
  - "download-stac"    # the actual executable


inputs:
  stac_url:
    type: string?
    inputBinding:
      prefix: --url
  stac_string:
    type: string?
    inputBinding:
      prefix: --string
  output_path_base:
    type: string
    inputBinding:
      prefix: --output-path
  method:
    type: string?
    inputBinding:
      prefix: --method
    default: ASSET


outputs:
  staged_root:
    type: Directory
    outputBinding:
      glob: $(inputs.output_path_base)