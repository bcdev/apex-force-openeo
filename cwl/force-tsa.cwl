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
      - $import: force-tsa-parameter-schema.yaml
baseCommand: /opt/apex-force-wrapper/bin/force-tsa-wrapper.sh
# Inputs are defined in the FORCE documentation: https://force-eo.readthedocs.io/en/stable/components/higher-level/tsa/param.html
inputs:
  data_cube:
    type: Directory
    inputBinding:
      prefix: --dir_input_data

  time_range:
    type: string[]
    inputBinding:
      prefix: --time_range
  doy_range:
    type: integer[]
    inputBinding:
      prefix: --doy_range
    default:
      - 1
      - 366
  x_tile_range:
    type: integer[]
    inputBinding:
      prefix: --x_tile_range
    default:
      - -999
      - 9999
  y_tile_range:
    type: integer[]
    inputBinding:
      prefix: --y_tile_range
    default:
      - -999
      - 9999
  file_tile:
    type: string[]
    inputBinding:
      prefix: --file_tile
    default: NULL

  chunk_size:
    type: integer[]
    inputBinding:
      prefix: --chunk_size
    default:
      - 0
      - 0
  resolution:
    type: integer
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
    type: enum[]
      symbols:
        - SEN2A
        - SEN2B
        - SEN3C
    inputBinding:
      prefix: --sensors
    default:
      - SEN2A
      - SEN2B
      - SEN2C
  target_sensors:
    type: enum
      symbols:
        - SEN2L
        - SEN2A
        - SEN2B
        - SEN3C
    inputBinding:
      prefix: --target_sensors
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
    type: enum[]
      symbols:
        - NODATA
        - CLOUD_OPAQUE
        - CLOUD_BUFFER
        - CLOUD_CIRRUS
        - CLOUD_SHADOW
        - SNOW
        - WATER
        - AOD_FILL
        - AOD_HIGH
        - AOD_INT
        - SUBZERO
        - SATURATION
        - SUN_LOW
        - ILLUMIN_NONE
        - ILLUMIN_POOR
        - ILLUMIN_LOW
        - SLOPED
        - WVP_NONE
    inputBinding:
      prefix: --screen_qai
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
    type: enum[]
      symbols:
        - B1
        - B2
        - B3
        - B4
        - B5
        - B6
        - B7
        - B8
        - B8A
        - B9
        - B10
        - B11
        - B12
        - SMA
        - NDVI
        - EVI
        - NBR
        - NDTI
        - ARVI
        - SAVI
        - SARVI
        - TC-BRIGHT
        - TC-GREEN
        - TC-WET
        - TC-DI
        - NDBI
        - NDWI
        - MNDWI
        - NDMI
        - NDSI
        - kNDVI
        - NDRE1
        - NDRE2
        - CIre
        - NDVIre1
        - NDVIre2
        - NDVIre3
        - NDVIre1n
        - NDVIre2n
        - NDVIre3n
        - MSRre
        - MSRren
        - CCI
        - EVI2
        - ContRemSWIR
    inputBinding:
      prefix: --index
    default:
  standardize_tss:
    type: enum
      symbols:
        - NONE
        - NORMALIZE
        - CENTER
    inputBinding:
      prefix: --standardize_tss
    default: NONE
  output_tss:
    type: boolean
    inputBinding:
      prefix: --output_tss
    default: false

  interpolate:
    type: enum
      symbols:
        - NONE
        - LINEAR
        - MOVING
        - RBF
        - HARMONIC
    inputBinding:
      prefix: --interpolate
    default: NONE
  moving_max:
    type: integer
    inputBinding:
      prefix: --moving_max
    default: 16
  rbf_sigma:
    type: integer[]
    inputBinding:
      prefix: --rbf_sigma
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
    type: integer
    inputBinding:
      prefix: --harmonic_modes
    default: 3
  harmonic_fit_range:
    type: string[]
    inputBinding:
      prefix: --harmonic_fit_range
    Default: NULL,NULL
  output_nrt:
    type: boolean
    inputBinding:
      prefix: --output_nrt
    default: false
  int_days:
    type: integer
    inputBinding:
      prefix: --int_days
    default: 16
  standardize_tsi:
    type: enum
      symbols:
        - NONE
        - NORMALIZE
        - CENTER
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
    type: enum[]
      symbols:
        - MIN
        - Q01
        - Q05
        - Q10
        - Q20
        - Q25
        - Q30
        - Q40
        - Q50
        - Q60
        - Q70
        - Q75
        - Q80
        - Q90
        - Q95
        - Q99
        - MAX
        - AVG
        - STD
        - RNG
        - IQR
        - SKW
        - KRT
        - NUM
        - NONE
    inputBinding:
      prefix: --stm
    default: NONE

  fold_type:
    type: enum[]
      symbols:
        - MIN
        - Q10
        - Q25
        - Q50
        - Q75
        - Q90
        - MAX
        - AVG
        - STD
        - RNG
        - IQR
        - SKW
        - KRT
        - NUM
    inputBinding:
      prefix: --fold_type
    default: AVG
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
    type: enum[]
      symbols:
        - DEM
        - DLM
        - DPS
        - DSS
        - DMS
        - DES
        - DEV
        - DAV
        - DLV
        - LTS
        - LGS
        - LGV
        - VEM
        - VLM
        - VPS
        - VSS
        - VMS
        - VES
        - VEV
        - VAV
        - VLV
        - VBL
        - VGA
        - VSA
        - VPA
        - VGM
        - VGV
        - DPY
        - DPV
        - IST
        - IBL
        - IBT
        - IGS
        - IRR
        - IFR
        - RAR
        - RAF
        - RMR
        - RMF
    inputBinding:
      prefix: --pol
    default:
  standardize_pol:
    type: enum
      symbols:
        - NONE
        - NORMALIZE
        - CENTER
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
    type: enum
      symbols:
        - LEFT
        - TWO
        - RIGHT
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
    type: enum
      symbols:
        - GTiff
        - COG
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

