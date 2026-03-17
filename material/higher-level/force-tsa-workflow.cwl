cwlVersion: v1.2
class: Workflow
requirements:
  SchemaDefRequirement:
    types:
      - $import: force-tsa-parameter-schema.yaml

inputs:
  item_url:
    type: string
  STM:
    type: force-tsa-parameter-schema.yaml#STM_type[]
    default:
      - MIN

outputs:
  tsa_cube:
    type: Directory
    outputSource: force_tsa/tsa_cube

steps:
  staging:
    run: staging.cwl
    in:
      item_url: item_url
      output_path_base:
        default: "staging"
    out: [staged_root]
  force_tsa:
    run: force-tsa.cwl
    in:
      data_cube: staging/staged_root
      STM: STM
    out: [tsa_cube]