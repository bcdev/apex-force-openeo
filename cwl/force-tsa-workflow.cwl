cwlVersion: v1.2
class: Workflow
requirements:
  SchemaDefRequirement:
    types:
      - $import: force-enums.yml

inputs:
  stac_url:
    type: string?
  name:
    type: string?
  date_range:
    type: string[]
  doy_range:
    type: int[]
    default:
      - 1
      - 365

  x_tile_range:
    type: int[]
    default:
      - -999
      - 9999

  y_tile_range:
    type: int[]
    default:
      - -999
      - 9999

  file_tile:
    type: string[]
    default: NULL

  chunk_size:
    type: int[]
    default:
      - 7500
      - 7500

  resolution:
    type: int
    default: 20

  reduce_psf:
    type: boolean
    default: false

  use_l2_improphe:
    type: boolean
    default: false

  sensors:
    type: force-enums.yml#sensors_type[]
    default:
      - SEN2A
      - SEN2B
      - SEN2C

  target_sensor:
    type: force-enums.yml#sensors_type
    default: SEN2L

  product_type_main:
    type: string
    default: BOA

  product_type_quality:
    type: string
    default: QAI

  spectral_adjust:
    type: boolean
    default: false

  screen_qai:
    type: force-enums.yml#screen_qai_type[]
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
    default: 0

  below_noise:
    type: float
    default: 0

  index:
    type: force-enums.yml#index_type[]
    default:
      - NDVI
      - EVI
      - NBR

  standardize_tss:
    type: force-enums.yml#standardize_type
    default: NONE

  output_tss:
    type: boolean
    default: false

  interpolate:
    type: force-enums.yml#interpolate_type
    default: NONE

  moving_max:
    type: int
    default: 16

  rbf_sigma:
    type: int[]
    default:
     - 8
     - 16
     - 32

  rbf_cutoff:
    type: float
    default: 0.95

  harmonic_trend:
    type: boolean
    default: false

  harmonic_modes:
    type: int
    default: 3

  harmonic_fit_range:
    type: string[]
    default:
      - 1970-01-01
      - 2099-01-01

  output_nrt:
    type: boolean
    default: false

  int_day:
    type: int
    default: 16

  standardize_tsi:
    type: force-enums.yml#standardize_type
    default: NONE

  output_tsi:
    type: boolean
    default: false

  output_stm:
    type: boolean
    default: false

  stm:
    type: force-enums.yml#stm_type[]
    default:
      - NONE

  fold_type:
    type: force-enums.yml#fold_type_type[]
    default:
      - AVG

  standardize_fold:
    type: force-enums.yml#standardize_type
    default: NONE

  output_fby:
    type: boolean
    default: false

  output_fbq:
    type: boolean
    default: false

  output_fbm:
    type: boolean
    default: false

  output_fbw:
    type: boolean
    default: false

  output_fbd:
    type: boolean
    default: false

  output_try:
    type: boolean
    default: false

  output_trq:
    type: boolean
    default: false

  output_trm:
    type: boolean
    default: false

  output_trw:
    type: boolean
    default: false

  output_trd:
    type: boolean
    default: false

  output_cay:
    type: boolean
    default: false

  output_caq:
    type: boolean
    default: false

  output_cam:
    type: boolean
    default: false

  output_caw:
    type: boolean
    default: false

  output_cad:
    type: boolean
    default: false

  pol_start_threshold:
    type: float
    default: 0.2

  pol_mid_threshold:
    type: float
    default: 0.5

  pol_end_threshold:
    type: float
    default: 0.8

  pol_adaptive:
    type: boolean
    default: false

  pol:
    type: force-enums.yml#pol_type[]
    default:
      - VSS
      - VPS
      - VES
      - VSA
      - RMR
      - IGS

  standardize_pol:
    type: force-enums.yml#standardize_type
    default: NONE

  output_pct:
    type: boolean
    default: false

  output_pol:
    type: boolean
    default: false

  output_tro:
    type: boolean
    default: false

  output_cao:
    type: boolean
    default: false

  trend_tail:
    type: force-enums.yml#trend_tail_type
    default: TWO

  trend_conf:
    type: float
    default: 0.95

  change_penalty:
    type: boolean
    default: false

  output_format:
    type: force-enums.yml#output_format_type
    default: GTiff

  output_explode:
    type: boolean
    default: false

  fail_if_empty:
    type: boolean
    default: false

outputs:
  tsa_cube:
    type: Directory
    outputSource: force_tsa/tsa_cube

steps:
  staging:
    run: staging.cwl
    in:
      stac_url: stac_url
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