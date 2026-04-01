cwlVersion: v1.2

class: CommandLineTool
requirements:
  DockerRequirement:
    dockerPull: quay.io/bcdev/force-eoap:0.0.12
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
      - $import: force-enums.yml
baseCommand: /opt/apex-force-wrapper/bin/force-tsa-wrapper.sh
# Inputs are defined in the FORCE documentation: https://force-eo.readthedocs.io/en/stable/components/higher-level/tsa/param.html
inputs:
  input_data_dir:
    type: Directory
    inputBinding:
      prefix: --input_data_dir

  name:
    type: string?
    inputBinding:
      prefix: --name

  date_range:
    type: string[]
    inputBinding:
      prefix: --date_range
      itemSeparator: ","

  doy_range:
    type: int[]
    inputBinding:
      prefix: --doy_range
      itemSeparator: ","
    default:
      - 1
      - 365

  x_tile_range:
    type: int[]
    inputBinding:
      prefix: --x_tile_range
      itemSeparator: ","
    default:
      - -999
      - 9999

  y_tile_range:
    type: int[]
    inputBinding:
      prefix: --y_tile_range
      itemSeparator: ","
    default:
      - -999
      - 9999

  file_tile:
    type: string[]
    inputBinding:
      prefix: --file_tile
      itemSeparator: ","
    default: NULL

  chunk_size:
    type: int[]
    inputBinding:
      prefix: --chunk_size
      itemSeparator: ","
    default:
      - 7500
      - 7500

  resolution:
    type: int
    inputBinding:
      prefix: --resolution
    default: 20

  reduce_psf:
    type: boolean
    inputBinding:
      prefix: --reduce_psf
    default: false

  use_l2_improphe:
    type: boolean
    inputBinding:
      prefix: --use_l2_improphe
    default: false

  sensors:
    type: force-enums.yml#sensors_type[]
    inputBinding:
      prefix: --sensors
      itemSeparator: ","
    default:
      - SEN2A
      - SEN2B
      - SEN2C

  target_sensor:
    type: force-enums.yml#sensors_type
    inputBinding:
      prefix: --target_sensor
    default: SEN2L

  product_type_main:
    type: string
    inputBinding:
      prefix: --product_type_main
    default: BOA

  product_type_quality:
    type: string
    inputBinding:
      prefix: --product_type_quality
    default: QAI

  spectral_adjust:
    type: boolean
    inputBinding:
      prefix: --spectral_adjust
    default: false

  screen_qai:
    type: force-enums.yml#screen_qai_type[]
    inputBinding:
      prefix: --screen_qai
      itemSeparator: ","
    default:
      - NODATA
      - CLOUD_OPAQUE
      - CLOUD_BUFFER
      - CLOUD_CIRRUS
      - CLOUD_SHADOW
      - SNOW
      - SUBZERO
      - SATURATION

  above_noise:
    type: float
    inputBinding:
      prefix: --above_noise
    default: 0

  below_noise:
    type: float
    inputBinding:
      prefix: --below_noise
    default: 0

  index:
    type: force-enums.yml#index_type[]
    inputBinding:
      prefix: --index
      itemSeparator: ","
    default:
      - NDVI
      - EVI
      - NBR

  standardize_tss:
    type: force-enums.yml#standardize_type
    inputBinding:
      prefix: --standardize_tss
    default: NONE

  output_tss:
    type: boolean
    inputBinding:
      prefix: --output_tss
    default: false

  interpolate:
    type: force-enums.yml#interpolate_type
    inputBinding:
      prefix: --interpolate
    default: NONE

  moving_max:
    type: int
    inputBinding:
      prefix: --moving_max
    default: 16

  rbf_sigma:
    type: int[]
    inputBinding:
      prefix: --rbf_sigma
      itemSeparator: ","
    default:
     - 8
     - 16
     - 32

  rbf_cutoff:
    type: float
    inputBinding:
      prefix: --rbf_cutoff
    default: 0.95

  harmonic_trend:
    type: boolean
    inputBinding:
      prefix: --harmonic_trend
    default: false

  harmonic_modes:
    type: int
    inputBinding:
      prefix: --harmonic_modes
    default: 3

  harmonic_fit_range:
    type: string[]
    inputBinding:
      prefix: --harmonic_fit_range
      itemSeparator: ","
    default:
      - 1970-01-01
      - 2099-01-01

  output_nrt:
    type: boolean
    inputBinding:
      prefix: --output_nrt
    default: false

  int_day:
    type: int
    inputBinding:
      prefix: --int_day
    default: 16

  standardize_tsi:
    type: force-enums.yml#standardize_type
    inputBinding:
      prefix: --standardize_tsi
    default: NONE

  output_tsi:
    type: boolean
    inputBinding:
      prefix: --output_tsi
    default: false

  output_stm:
    type: boolean
    inputBinding:
      prefix: --output_stm
    default: false

  stm:
    type: force-enums.yml#stm_type[]
    inputBinding:
      prefix: --stm
      itemSeparator: ","
    default: NONE

  fold_type:
    type: force-enums.yml#fold_type_type[]
    inputBinding:
      prefix: --fold_type
      itemSeparator: ","
    default:
      - AVG

  standardize_fold:
    type: force-enums.yml#standardize_type
    inputBinding:
      prefix: --standardize_fold
    default: NONE

  output_fby:
    type: boolean
    inputBinding:
      prefix: --output_fby
    default: false

  output_fbq:
    type: boolean
    inputBinding:
      prefix: --output_fbq
    default: false

  output_fbm:
    type: boolean
    inputBinding:
      prefix: --output_fbm
    default: false

  output_fbw:
    type: boolean
    inputBinding:
      prefix: --output_fbw
    default: false

  output_fbd:
    type: boolean
    inputBinding:
      prefix: --output_fbd
    default: false

  output_try:
    type: boolean
    inputBinding:
      prefix: --output_try
    default: false

  output_trq:
    type: boolean
    inputBinding:
      prefix: --output_trq
    default: false

  output_trm:
    type: boolean
    inputBinding:
      prefix: --output_trm
    default: false

  output_trw:
    type: boolean
    inputBinding:
      prefix: --output_trw
    default: false

  output_trd:
    type: boolean
    inputBinding:
      prefix: --output_trd
    default: false

  output_cay:
    type: boolean
    inputBinding:
      prefix: --output_cay
    default: false

  output_caq:
    type: boolean
    inputBinding:
      prefix: --output_caq
    default: false

  output_cam:
    type: boolean
    inputBinding:
      prefix: --output_cam
    default: false

  output_caw:
    type: boolean
    inputBinding:
      prefix: --output_caw
    default: false

  output_cad:
    type: boolean
    inputBinding:
      prefix: --output_cad
    default: false

  pol_start_threshold:
    type: float
    inputBinding:
      prefix: --pol_start_threshold
    default: 0.2

  pol_mid_threshold:
    type: float
    inputBinding:
      prefix: --pol_mid_threshold
    default: 0.5

  pol_end_threshold:
    type: float
    inputBinding:
      prefix: --pol_end_threshold
    default: 0.8

  pol_adaptive:
    type: boolean
    inputBinding:
      prefix: --pol_adaptive
    default: false

  pol:
    type: force-enums.yml#pol_type[]
    inputBinding:
      prefix: --pol
      itemSeparator: ","
    default:
      - VSS
      - VPS
      - VES
      - VSA
      - RMR
      - IGS

  standardize_pol:
    type: force-enums.yml#standardize_type
    inputBinding:
      prefix: --standardize_pol
    default: NONE

  output_pct:
    type: boolean
    inputBinding:
      prefix: --output_pct
    default: false

  output_pol:
    type: boolean
    inputBinding:
      prefix: --output_pol
    default: false

  output_tro:
    type: boolean
    inputBinding:
      prefix: --output_tro
    default: false

  output_cao:
    type: boolean
    inputBinding:
      prefix: --output_cao
    default: false

  trend_tail:
    type: force-enums.yml#trend_tail_type
    inputBinding:
      prefix: --trend_tail
    default: TWO

  trend_conf:
    type: float
    inputBinding:
      prefix: --trend_conf
    default: 0.95

  change_penalty:
    type: boolean
    inputBinding:
      prefix: --change_penalty
    default: false

  output_format:
    type: force-enums.yml#output_format_type
    inputBinding:
      prefix: --output_format
    default: GTiff

  output_explode:
    type: boolean
    inputBinding:
      prefix: --output_explode
    default: false

  fail_if_empty:
    type: boolean
    inputBinding:
      prefix: --fail_if_empty
    default: false

outputs:
  tsa_cube:
    type: Directory
    outputBinding:
      glob: "."
