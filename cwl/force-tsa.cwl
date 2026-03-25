cwlVersion: v1.2

class: CommandLineTool
requirements:
  DockerRequirement:
    dockerPull: quay.io/bcdev/force-eoap:dev
  NetworkAccess:
    networkAccess: true # TODO is this needed, if we can download independently?
  ResourceRequirement:
    # TODO set reasonable limits
    ramMin: 7000
    ramMax: 7000
    coresMin: 1
    coresMax: 4
  SchemaDefRequirement:
    types:
      - $import: force-tsa-parameter-schema.yaml
baseCommand: /opt/apex-force-wrapper/bin/force-tsa-wrapper.sh
# Inputs are defined in the FORCE documentation: https://force-eo.readthedocs.io/en/stable/components/higher-level/tsa/param.html
inputs:
  data_cube:
    type: Directory
    inputBinding:
      prefix: --DIR_INPUT_DATA
  STM:
    type: force-tsa-parameter-schema.yaml#STM_type[]
    inputBinding:
      prefix:
        --STM
      itemSeparator: ","
    default:
      - MIN
      - MAX
  # TODO better type than string?
  DATE_RANGE_START:
    type: string
    inputBinding:
      prefix:
        --DATE_RANGE_START
  DATE_RANGE_END:
    type: string
    inputBinding:
      prefix:
        --DATE_RANGE_END
outputs:
  tsa_cube:
    type: Directory
    outputBinding:
      glob: "outputs/hlps-tsa"
  stac_catalog:
    type: File
    outputBinding:
      glob: "outputs/stac/catalog.json"
  stac_items:
    type: Directory
    outputBinding:
      glob: "outputs/stac/*hlps-tsa"

