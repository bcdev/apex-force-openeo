cwlVersion: v1.2

class: CommandLineTool
requirements:
  NetworkAccess:
    networkAccess: true
  DockerRequirement:
    dockerPull: quay.io/bcdev/force-eoap:dev
    # dockerImageId: quay.io/bcdev/force-eoap:dev

baseCommand: /opt/uv/uv
arguments:
  - "run"
  - "--no-sync"        # use locked python environment from container
  - "--project"
  - "/opt/force-python-tools"
  - "download-item"    # the actual executable


inputs:
  item_url:
    type: string
    inputBinding:
      prefix: --url
  output_path_base:
    type: string
    inputBinding:
      prefix: --output-path

outputs:
  staged_root:
    type: Directory
    outputBinding:
      glob: $(inputs.output_path_base)/*