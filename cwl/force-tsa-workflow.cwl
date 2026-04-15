cwlVersion: v1.2
class: Workflow
requirements:
  SchemaDefRequirement:
    types:
      - $import: force-enums.yaml

inputs:
  item_url:
    type: string
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
      name: name
      date_range: date_range
      doy_range: doy_range
      x_tile_range: x_tile_range
      y_tile_range: y_tile_range
      file_tile: file_tile
      chunk_size: chunk_size
      resolution: resolution
      reduce_psf: reduce_psf
      use_l2_improphe: use_l2_improphe
      sensors: sensors
      target_sensor: target_sensor
      product_type_main: product_type_main
      product_type_quality: product_type_quality
      spectral_adjust: spectral_adjust
      screen_qai: screen_qai
      above_noise: above_noise
      below_noise: below_noise
      index: index
      standardize_tss: standardize_tss
      output_tss: output_tss
      interpolate: interpolate
      moving_max: moving_max
      rbf_sigma: rbf_sigma
      rbf_cutoff: rbf_cutoff
      harmonic_trend: harmonic_trend
      harmonic_modes: harmonic_modes
      harmonic_fit_range: harmonic_fit_range
      output_nrt: output_nrt
      int_day: int_day
      standardize_tsi: standardize_tsi
      output_tsi: output_tsi
      output_stm: output_stm
      stm: stm
      fold_type: fold_type
      standardize_fold: standardize_fold
      output_fby: output_fby
      output_fbq: output_fbq
      output_fbm: output_fbm
      output_fbw: output_fbw
      output_fbd: output_fbd
      output_try: output_try
      output_trq: output_trq
      output_trm: output_trm
      output_trw: output_trw
      output_trd: output_trd
      output_cay: output_cay
      output_caq: output_caq
      output_cam: output_cam
      output_caw: output_caw
      output_cad: output_cad
      pol_start_threshold: pol_start_threshold
      pol_mid_threshold: pol_mid_threshold
      pol_end_threshold: pol_end_threshold
      pol_adaptive: pol_adaptive
      pol: pol
      standardize_pol: standardize_pol
      output_pct: output_pct
      output_pol: output_pol
      output_tro: output_tro
      output_cao: output_cao
      trend_tail: trend_tail
      trend_conf: trend_conf
      change_penalty: change_penalty
      output_format: output_format
      output_explode: output_explode
      fail_if_empty: fail_if_empty
    out: [tsa_cube]