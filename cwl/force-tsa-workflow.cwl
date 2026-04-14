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
  date_range:
    type: string[]

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
      input_data_dir: staging/staged_root
      STM: STM
      date_range: date_range
    out: [tsa_cube]