cwlVersion: v1.2
class: Workflow
id: force_tsa_wf
label: FORCE Time Series Analysis workflow
doc: |
 FORCE Time Series Analysis higher level process.
 Wraps the FORCE Higher Level Processing System module "Time Series Analysis", described as follows:

 The Time Series Analysis submodule provides out-of-the-box time series preparation and analysis functionality.

 Documentation: https://esa-apex.github.io/apex_toolbox_documentation/docs/force/guide/tsa.html
 FORCE documentation: https://force-eo.readthedocs.io/en/latest/components/higher-level/tsa/index.html
requirements:
  SchemaDefRequirement:
    types:
      - $import: force-enums.yml

inputs:
  stac_url:
    type: string?
    label: URL to the level 2 data cube STAC
    doc: |
      URL pointing to a STAC catalog or item describing a FORCE level 2 data cube
      that should be used as input for the TSA processing.
  name:
    type: string?
    label: Production name
    doc: |
      Name of the datacube. Example: bologna . Default: cube-
      The name of the resulting STAC item is based on this name
  date_range:
    type: string[]
    label: Time extent for the analysis
    doc: |
      Time extent for the analysis. All data between these dates will be used in the analysis. Format YYYY-MM-DD
  doy_range:
    type: int[]
    default:
      - 1
      - 365
    label: DOY range for filtering the time extent
    doc: |
      DOY range for filtering the time extent. Day-of-Years that are outside of the given interval will be ignored.
      Example: DATE_RANGE = 2010-01-01 2019-12-31, DOY_RANGE = 91 273 will use all April-September observations from 2010-2019.
      If you want to extend this window over years give DOY min > DOY max.
      Example: DATE_RANGE = 2010-01-01 2019-12-31, DOY_RANGE = 274 90 will use all October-March observations from 2010-2019.
      Type: Integer list. Valid values: [1,366]. Default: 1 366

  x_tile_range:
    type: int[]
    label: Analysis extent x
    doc: |
      Analysis extent, given in tile numbers (see tile naming). Each existing tile falling into this square extent will be processed.

  y_tile_range:
    type: int[]
    label: Analysis extent y
    doc: |
     Analysis extent, given in tile numbers (see tile naming). Each existing tile falling into this square extent will be processed.
     A shapefile of the tiles can be generated with force-tabulate-grid.

  file_tile:
    type: string[]
    default: NULL
    label: Allow-list of tiles.
    doc: |
      Allow-list of tiles. Can be used to further limit the analysis extent to non-square extents.
      The allow-list is intersected with the analysis extent, i.e. only tiles included in both the analysis extent AND the allow-list will be processed.
      Default: NULL

  chunk_size:
    type: int[]
    default:
      - 7500
      - 7500
    label: Chunk Size (sub-tile processing unit size)
    doc: |
      This parameter is used to define the size of the sub-tile processing units.
      Most efficient is to use a chunk size that coincides with the tile size.
      Using smaller chunks may be necessary if you cannot fit all necessary data into RAM.
      The tilesize must be dividable by the chunk size without remainder.
      Note that setting the chunk size to 0 as was done with the deprecated BLOCK_SIZE parameter is not permitted anymore.

  resolution:
    type: int
    default: 20
    label: Analysis resolution in metres.
    doc: |
      Analysis resolution in metres. The tile (and chunk) size must be dividable by this resolution without remainder,
      e.g. 30m resolution with 100km tiles is not possible. Default: 20

  reduce_psf:
    type: boolean
    default: false
    label: Point Spread Function for spatial resolution reduction
    doc: |
      How to reduce spatial resolution for cases when the image resolution is higher than the analysis resolution.
      If FALSE, the resolution is degraded using Nearest Neighbor resampling (fast).
      If TRUE, an approx. Point Spread Function (Gaussian lowpass with FWHM = analysis resolution)
      is used to approximate the acquisition of data at lower spatial resolution

  use_l2_improphe:
    type: boolean
    default: false
    label: Use enhanced spatial resolution on ImproPhe'd products
    doc: |
      If you have spatially enhanced some Level 2 ARD using the FORCE Level 2 ImproPhe module,
      this switch specifies whether the data are used at original (False) or enhanced spatial resolution (True).
      If there are no improphe'd products, this switch doesn't have any effect. Default: False

  sensors:
    type: force-enums.yml#sensors_type[]
    default:
      - SEN2A
      - SEN2B
      - SEN2C
    label: Sensors to be used in the analysis
    doc: |
      Sensors to be used in the analysis. Multi-sensor analyses are restricted to the overlapping bands.
      Each sensor needs a sensor definition in the runtime-data directory. New sensors can be added by the user.
      New bandnames can be added, too. Default: SEN2A, SEN2B, SEN2C

  target_sensor:
    type: force-enums.yml#sensors_type
    default: SEN2L
    label: Target sensor that represents the combination of input sensors
    doc: |
      Target sensor that represents the combination of input sensors. A sensor definition for this target sensor needs
      to exist to make sure that processing those outputs will be possible. For example, if you combine Landsat 8
      and Sentinel-2, the target sensor containing the overlapping bands could be LNDLG. If only using Sentinel-2 sensors,
      the target sensor could be SEN2L. Valid values are the same as for SENSORS. Default: SEN2L

  product_type_main:
    type: string
    default: BOA
    label: Main product type to be used
    doc: |
      Main product type to be used. Usually, this is a reflectance product like BOA. When using composites, you may use BAP.
      This can be anything, but make sure that the string can uniquely identify your product. As an example, do not use LEVEL2.
      Note that the product should contain the bands that are to be expected with the sensor used, e.g. 10 bands when sensor is SEN2A.
      Type: Character. Valid values: {BOA,TOA,IMP,BAP,SIG,...}. Default: BOA

  product_type_quality:
    type: string
    default: QAI
    label: Quality product type to be used
    doc: |
      Quality product type to be used. This should be a bit flag product like QAI. When using composites, you may use INF.
      This can be anything, but make sure that the product should contain quality bit flags as outputted by FORCE L2PS.
      As an exception, it is also possible to give NULL if you don't have any quality masks.
      In this case, FORCE will only be able to filter nodata values, but no other quality flags as defined with SCREEN_QAI.
      Valid values: {QAI,INF,NULL,...}. Default: QAI


  spectral_adjust:
    type: boolean
    default: false
    label: Toggle to perform a spectral adjustment to Sentinel-2
    doc: |
      Perform a spectral adjustment to Sentinel-2? This method can only be used with following sensors:
      SEN2A, SEN2B, SEN2C, SEN2D,LND04, LND05, LND07, LND08, LND09, MOD01, MOD02.
      A material-specific spectral harmonization will be performed, which will convert the spectral response of any
      of these sensors to Sentinel-2A. Non-existent bands will be predicted, too. Default: False

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
    label: Screen Quality Information
    doc: |
      Valid values: {NODATA,CLOUD_OPAQUE,CLOUD_BUFFER,CLOUD_CIRRUS,CLOUD_SHADOW,SNOW,WATER,AOD_FILL,AOD_HIGH,AOD_INT,SUBZERO, SATURATION,SUN_LOW,ILLUMIN_NONE,ILLUMIN_POOR,ILLUMIN_LOW,SLOPED,WVP_NONE}. Default: NODATA CLOUD_OPAQUE CLOUD_BUFFER CLOUD_CIRRUS CLOUD_SHADOW SNOW SUBZERO SATURATION

  above_noise:
    type: float
    default: 0
    label: Threshold for removing outliers.
    doc: |
      Threshold for removing outliers. Triplets of observations are used to determine the overall noise in the
      time series by computing linearly interpolating between the bracketing observations.
      The RMSE of the residual between the middle value and the interpolation is the overall noise.
      Any observations, which have a residual larger than a multiple of the noise are iteratively filtered out (ABOVE_NOISE).
      Lower/Higher values filter more aggressively/conservatively. Likewise, any masked out observation
      (as determined by the SCREEN_QAI filter) can be restored if its residual is lower than a multiple of the noise (BELOW_NOISE).
      Higher/Lower values will restore observations more aggressively/conservative. Give 0 to both parameters to disable the filtering.
      ABOVE_NOISE = 3, BELOW_NOISE = 1 are parameters that have worked in some settings. Default: 0

  below_noise:
    type: float
    default: 0
    label: Threshold for removing outliers.
    doc: |
      Threshold for removing outliers. Triplets of observations are used to determine the overall noise in the time series
      by computing linearly interpolating between the bracketing observations. The RMSE of the residual between the middle value and the interpolation is the overall noise.
      Any observations, which have a residual larger than a multiple of the noise are iteratively filtered out (ABOVE_NOISE).
      Lower/Higher values filter more aggressively/conservatively. Likewise, any masked out observation
      (as determined by the SCREEN_QAI filter) can be restored if its residual is lower than a multiple of the noise (BELOW_NOISE).
      Higher/Lower values will restore observations more aggressively/conservative. Give 0 to both parameters to disable the filtering.
      ABOVE_NOISE = 3, BELOW_NOISE = 1 are parameters that have worked in some settings. Default: 0

  index:
    type: force-enums.yml#index_type[]
    default:
      - NDVI
      - EVI
      - NBR
    label: Spectral indices
    doc: |
      Any index defined in indices.json can be used, as well as SMA, or any band name present in the SENSORS band combination

  standardize_tss:
    type: force-enums.yml#standardize_type
    default: NONE
    label: Method to standardize TSS time series
    doc: |
      Standardize the TSS time series with pixel mean and/or standard deviation?

  output_tss:
    type: boolean
    default: false
    label: Toggle to quality-screened Time Series Stack
    doc: |
      Output the quality-screened Time Series Stack? This is a layer stack of index values for each date. Default: False

  interpolate:
    type: force-enums.yml#interpolate_type
    default: NONE
    label: Interpolation method
    doc: |
      Interpolation method. You can choose between no, linear, moving average, Radial Basis Function or harmonic Interpolation.
      Harmonic interpolation can be used as a simple near-real time monitoring component. sensors can be added by the user.
      New bandnames can be added, too. Default: NONE

  moving_max:
    type: int
    default: 16
    label: Max temporal distance for the moving average filter in days
    doc: |
      Max temporal distance for the moving average filter in days. For each interpolation date,
      MOVING_MAX days before and after are considered. Default: 16

  rbf_sigma:
    type: int[]
    default:
     - 8
     - 16
     - 32
    label: Sigma (width of the Gaussian bell) for the RBF filter in days
    doc: |
        Sigma (width of the Gaussian bell) for the RBF filter in days.
        For each interpolation date, a Gaussian kernel is used to smooth the observations.
        The smoothing effect is stronger with larger kernels and the chance of having nodata values is lower.
        Smaller kernels will follow the time series more closely but the chance of having nodata values is larger.
        Multiple kernels can be combined to take advantage of both small and large kernel sizes.
        The kernels are weighted according to the data density within each kernel. Default: 8 16 32

  rbf_cutoff:
    type: float
    default: 0.95
    label: Cutoff density for the RBF filter
    doc: |
      Cutoff density for the RBF filter. The Gaussian kernels have infinite width, which is computationally slow,
      and doesn't make much sense as observations that are way too distant (in terms of time) are considered.
      Thus, the tails of the kernel are cut off. This parameter specifies, which percentage of the area under the Gaussian should be used.
      Default: 0.95

  harmonic_trend:
    type: boolean
    default: false
    label: Toggle for using monotonic trend in the harmonic interpolation
    doc: |
      Whether a monotonic trend shall be considered in the harmonic interpolation. Default: True

  harmonic_modes:
    type: int
    default: 3
    label: number of modes per season are used for harmonic interpolation
    doc: |
      Definition of how many modes per season are used for harmonic interpolation, i.e. uni-modal (1), bi-modal (2), or tri-modal (3). Default: 3

  harmonic_fit_range:
    type: string[]
    default:
      - 1970-01-01
      - 2099-01-01
    label: Subset of the time period to which the harmonic should be fitted
    doc: |
      Subset of the time period to which the harmonic should be fitted.
      For example, if the analysis timeframe is DATE_RANGE = 2015-01-01 2022-06-20,all data from 2015-2022 will be considered.
      If HARMONIC_FIT_RANGE = 2015-01-01 2017-12-31,the harmonic will only be fitted to the first 3 years of data.

  output_nrt:
    type: boolean
    default: false
    label: Toggle to output near-real time product
    doc: |
      Output of the near-real time product? The product will contain the residual between the extrapolated harmonic
      and the actual data following the defined end of the harmonic fit range.
      This option requires harmonic interpolation (interpolate) and a forecast period (harmonic_fit_range).

  int_day:
    type: int
    default: 16
    label: interpolation step in days
    doc: |
      This parameter gives the interpolation step in days. Default: 16

  standardize_tsi:
    type: force-enums.yml#standardize_type
    default: NONE
    label: Standardization method for TSA time series
    doc: |
      Standardize the TSI time series with pixel mean and/or standard deviation. Default: NONE

  output_tsi:
    type: boolean
    default: false
    label: Toggle to output time series interpolation
    doc: |
      Output the Time Series Interpolation? This is a layer stack of index values for each interpolated date.
      Note that interpolation will be performed even if output_tsi = False - unless you specify interpolate = NONE.

  output_stm:
    type: boolean
    default: false
    label: Toggle to output Spectral Temporal Metrics
    doc: |
      Whether to output Spectral Temporal Metrics: Default: False

  stm:
    type: force-enums.yml#stm_type[]
    default:
      - NONE
    label: Spectral Temporal Metrics to be computed
    doc: |
      Which Spectral Temporal Metrics should be computed? The STM output files will have as many bands as you specify
      metrics (in the same order). Currently available statistics are
      the average, standard deviation, minimum, maximum, range, skewness, kurtosis, quantiles between 1-99%, and interquartile range.
      Note that median is Q50. Default: NONE

  fold_type:
    type: force-enums.yml#fold_type_type[]
    default:
      - AVG
    label: Statistics used for folding the time series
    doc: |
      Which statistic should be used for folding the time series? This parameter is only evaluated if one of
      the following outputs in this block is requested. Currently available statistics are the average,
      standard deviation, mini- mum, maximum, range, skewness, kurtosis, median, 10/25/75/90% quantiles, and interquartile range.
      Default: AVG


  standardize_fold:
    type: force-enums.yml#standardize_type
    default: NONE
    label: Standardization method for the FB* time series
    doc: |
      Standardize the FB* time series with pixel mean and/or standard deviation. Default: NONE

  output_fby:
    type: boolean
    default: false
    label: Toggle to output Fold-by-year time series
    doc: |
      Output the Fold-by-Year/Quarter/Month/Week/DOY time series? These are layer stacks of folded index values
      for each year, quarter, month, week or DOY.

  output_fbq:
    type: boolean
    default: false
    label: Toggle to output Fold-by-quarter time series
    doc: |
      Output the Fold-by-Year/Quarter/Month/Week/DOY time series? These are layer stacks of folded index values for each year, quarter, month, week or DOY.

  output_fbm:
    type: boolean
    default: false
    label: Toggle to output Fold-by-month time series
    doc: |
      Output the Fold-by-Year/Quarter/Month/Week/DOY time series? These are layer stacks of folded index values for each year, quarter, month, week or DOY.

  output_fbw:
    type: boolean
    default: false
    label: Toggle to output Fold-by-week time series
    doc: |
      Output the Fold-by-Year/Quarter/Month/Week/DOY time series? These are layer stacks of folded index values for each year, quarter, month, week or DOY.

  output_fbd:
    type: boolean
    default: false
    label: Toggle to output Fold-by-day time series
    doc: |
      Output the Fold-by-Year/Quarter/Month/Week/DOY time series? These are layer stacks of folded index values for each year, quarter, month, week or DOY.

  output_try:
    type: boolean
    default: false
    label: Toggle to output linear trend analysis of the fold-by-year time series
    doc: |
      Compute and output a linear trend analysis on any of the folded time series? Note that the OUTPUT_FBX parameters
      don't need to be TRUE to do this.

  output_trq:
    type: boolean
    default: false
    label: Toggle to output linear trend analysis of the fold-by-quarter time series
    doc: |
      Compute and output a linear trend analysis on any of the folded time series? Note that the OUTPUT_FBX parameters
      don't need to be TRUE to do this.

  output_trm:
    type: boolean
    default: false
    label: Toggle to output linear trend analysis of the fold-by-month time series
    doc: |
      Compute and output a linear trend analysis on any of the folded time series? Note that the OUTPUT_FBX parameters
      don't need to be TRUE to do this.

  output_trw:
    type: boolean
    default: false
    label: Toggle to output linear trend analysis of the fold-by-week time series
    doc: |
      Compute and output a linear trend analysis on any of the folded time series? Note that the OUTPUT_FBX parameters
      don't need to be TRUE to do this.

  output_trd:
    type: boolean
    default: false
    label: Toggle to output linear trend analysis of the fold-by-day time series
    doc: |
      Compute and output a linear trend analysis on any of the folded time series? Note that the OUTPUT_FBX parameters
      don't need to be TRUE to do this.

  output_cay:
    type: boolean
    default: false
    label: Toggle to output Change, Aftereffect, Trend analysis of the fold-by-year time series
    doc: |
      Compute and output an extended Change, Aftereffect, Trend (CAT) analysis on any of the folded time series?
      Note that the OUTPUT_FBX parameters don't need to be TRUE to do this.

  output_caq:
    type: boolean
    default: false
    label: Toggle to output Change, Aftereffect, Trend analysis of the fold-by-quarter time series
    doc: |
      Compute and output an extended Change, Aftereffect, Trend (CAT) analysis on any of the folded time series?
      Note that the OUTPUT_FBX parameters don't need to be TRUE to do this.

  output_cam:
    type: boolean
    default: false
    label: Toggle to output Change, Aftereffect, Trend analysis of the fold-by-month time series
    doc: |
      Compute and output an extended Change, Aftereffect, Trend (CAT) analysis on any of the folded time series?
      Note that the OUTPUT_FBX parameters don't need to be TRUE to do this.

  output_caw:
    type: boolean
    default: false
    label: Toggle to output Change, Aftereffect, Trend analysis of the fold-by-week time series
    doc: |
      Compute and output an extended Change, Aftereffect, Trend (CAT) analysis on any of the folded time series?
      Note that the OUTPUT_FBX parameters don't need to be TRUE to do this.

  output_cad:
    type: boolean
    default: false
    label: Toggle to output Change, Aftereffect, Trend analysis of the fold-by-day time series
    doc: |
      Compute and output an extended Change, Aftereffect, Trend (CAT) analysis on any of the folded time series?
      Note that the OUTPUT_FBX parameters don't need to be TRUE to do this.

  pol_start_threshold:
    type: float
    default: 0.2
    label: Threshold for detecting a start of season in the cumulative time series
    doc: |
      Threshold for detecting a start of season in the cumulative time series. Default: 0.2

  pol_mid_threshold:
    type: float
    default: 0.5
    label: Threshold for detecting a mid of season in the cumulative time series
    doc: |
      Threshold for detecting a mid of season in the cumulative time series. Default: 0.5

  pol_end_threshold:
    type: float
    default: 0.8
    label: Threshold for detecting an end of season in the cumulative time series
    doc: |
      Threshold for detecting an end of season in the cumulative time series. Default: 0.8

  pol_adaptive:
    type: boolean
    default: false
    label: Toggle to make the start of each phenological year adaptive
    doc: |
      Should the start of each phenological year be adapated? If FALSE, the start is static,
      i.e. Date of Early Minimum and Date of Late Minimum are the same for all years and 365 days apart.
      If TRUE, they differ from year to year and a phenological year is not forced to be 365 days long.

  pol:
    type: force-enums.yml#pol_type[]
    default:
      - VSS
      - VPS
      - VES
      - VSA
      - RMR
      - IGS
    label: Polarimetrics to be computed
    doc: |
      Which Polarmetrics should be computed? There will be a POL output file for each metric (with years as bands).
      Currently available are the dates of the early minimum, late minimum, peak of season, start of season,
      mid of season, end of season, early average vector, average vector, late average vector;
      lengths of the total season, green season, between average vectors; values of the early minimum, late minimum,
      peak of season, start of season, mid of season, end of season, early average vector, average vector,
      late average vector, base level, green amplitude, seasonal amplitude, peak amplitude, green season mean,
      green season variability, dates of start of phenological year, difference between start of phenological year
      and its longterm average; integrals of the total season, base level, base+total, green season, rising rate,
      falling rate; rates of average rising, average falling, maximum rising, maximum falling.


  standardize_pol:
    type: force-enums.yml#standardize_type
    default: NONE
    label: Standardization method for the POL time series
    doc: |
      Standardize the POL time series with pixel mean and/or standard deviation.

  output_pct:
    type: boolean
    default: false
    label: Toggle to output the polar-transformed time series
    doc: |
      Output the polar-transformed time series? These are layer stack of cartesian X- and Y-coordinates for each interpolated date.
      This results in two files, product IDs are PCX and PCY.

  output_pol:
    type: boolean
    default: false
    label: Toggle to output the polarmetrics
    doc: |
      Output the Polarmetrics? These are layer stacks per polarmetric with as many bands as years.

  output_tro:
    type: boolean
    default: false
    label: Toggle to output a linear trend analysis on the polarmetric time series
    doc: |
      Compute and output a linear trend analysis on the requested Polarmetric time series?
      Note that the OUTPUT_POL parameters don't need to be TRUE to do this.

  output_cao:
    type: boolean
    default: false
    label: Toggle to output Change, Aftereffect, Trend (CAT) analysis on the requested Polarmetric time series
    doc: |
      Compute and output an extended Change, Aftereffect, Trend (CAT) analysis on the requested Polarmetric time series?
      Note that the OUTPUT_POL parameters don't need to be TRUE to do this.

  trend_tail:
    type: force-enums.yml#trend_tail_type
    default: TWO
    label: Tail type for significance testing
    doc: |
      This parameter specifies the tail-type used for significance testing of the slope in the trend analysis.
      A left-, two-, or right-tailed t-test is performed.

  trend_conf:
    type: float
    default: 0.95
    label: Confidence level for significance testing of the slope in the trend analysis
    doc: |
      Confidence level for significance testing of the slope in the trend analysis. Default: 0.95

  change_penalty:
    type: boolean
    default: false
    label: Toggle for penalty on non-permanent change for change detection in CAT analysis
    doc: |
      In the Change, Aftereffect, Trend (CAT) analysis: do you want to put a penalty on non-permanent change for the change detection?
      This can help to reduce the effect of outliers.

  output_format:
    type: force-enums.yml#output_format_type
    default: GTiff
    label:
    doc: |
      Output format, which is either uncompressed flat binary image format aka ENVI Standard, GeoTiff, or COG.
      GeoTiff images are compressed with ZSTD and horizontal differencing; BigTiff support is enabled;
      the Tiff is internally tiled with 256x256 px blocks. Metadata are written to the ENVI header or directly into
      the Tiff to the FORCE domain. If the size of the metadata exceeds the Tiff's limit, an external .aux.xml
      file is additionally generated. Note that COG output is only possible when the chunk size matches the tile size.
      Default: GTiff

  output_explode:
    type: boolean
    default: false
    label: Toggle to output single-band files instead of a multi-band image
    doc: |
      controls whether the output is written as multi-band image, or whether the stack will be exploded into single-band files.
      Default: False

  fail_if_empty:
    type: boolean
    default: false
    label:
    doc: |
      Controls whether FORCE raises a warning or an error if no read or written bytes are detected.
      The default (False) will result in a warning. Default: False

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