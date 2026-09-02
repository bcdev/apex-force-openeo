cwlVersion: v1.2
class: Workflow
id: force_level2_wf
label: FORCE level 2 workflow
doc: |
 FORCE level 2 ARD generation process.
 Wraps the FORCE Level 2 Processing System, described as follows:
 The FORCE Level 2 Processing System (FORCE L2PS) generates harmonized, standardized, geometrically and radiometrically consistent Level 2 products with per-pixel quality information, i.e. Analysis Ready Data (ARD).

 Documentation: https://esa-apex.github.io/apex_toolbox_documentation/docs/force/guide/level2.html
 FORCE documentation: /home/hannes/projects/apex/apex-force-openeo/cwl/force-l2-workflow.cwl
requirements:
  SchemaDefRequirement:
    types:
      - $import: force-level2-enums.yml
  InlineJavascriptRequirement: {}
inputs:
  stac_url:
    type: string?
    label: URL to the STAC document describing the input products
    doc: |
      URL pointing to a STAC catalog, ItemCollection or Item containing the input products to be used for the analysis.
      Exactly one of stac_url or stac_document must be provided.
  stac_document:
    type: Any?
    label: STAC object describing the input products
    doc: |
      STAC catalog, ItemCollection or Item (as a dictionary) containing the input products to be used for the analysis.
      Exactly one of stac_url or stac_document must be provided.
  aoi:
    type: string?
    label: Area of interest as geojson feature
    doc: |
      Area of interest as geojson feature, extent of the resulting cube.
      Example: { "type": "Feature", "geometry": { "type": "Polygon", "coordinates": [[[10.5,44.0],[10.5,45.0],[11.5,45.0],[11.5,44.0],[10.5,44.0]]] }, "properties": { "name": "Bologna" } } .
      Default: not set, extent determined by inputs

  block_size:
    type: int?
    label: Block size of the image chips
    doc: |
      Block size (in target units, commonly in meters) of the image chips. Blocks are stripes,
      i.e. they are as wide as the tile and as high as specified here. Not used if projection is one of the predefined projections.
      Default: 3000
  buffer_nodata:
    type: boolean?
    label: Toggle for 1 pixel buffer for nodata pixels
    doc: |
      Defines whether nodata pixels should be buffered by 1 pixel. Default: False
  cirrus_buffer:
    type: int?
    label: Cirrus buffer radius (m)
    doc: |
      Buffer sizes (radius in meters) for cirrus masks. Default: 0
  cloud_buffer:
    type: int?
    label: Cloud Buffer radius (m)
    doc: |
      Buffer sizes (radius in meters) for cloud masks. Default: 300
  cloud_threshold:
    type: float?
    label: Fmask threshold
    doc: |
      Threshold of the Fmask algorithm. Default: 0.225
  dem:
    type: force-level2-enums.yml#dem?
    label: Name of digital elevation model
    doc: |
      Name of digital elevation model (Copernicus_30m supported on CDSE). Default: Copernicus_30m
  do_adjacency:
    type: boolean?
    label: Toggle to perform adjacency effect correction
    doc: |
      Indicates whether adjacency effect correction shall be performed. Default: True
  do_aod:
    type: boolean?
    label: Toggle to use internal AOD estimation
    doc: |
      Indicates whether the internal AOD estimation (True) or externally generated AOD values shall be used (False).
      Only True is supported on CDSE. Default: True
  do_atmo:
    type: boolean?
    label: Toggle to perform atmospheric correction
    doc: |
      Indicates whether atmospheric correction shall be performed. If True, Bottom-of-Atmosphere reflectance is computed.
      If False, only Top-of-Atmosphere reflectance is computed. Default: True
  do_brdf:
    type: boolean?
    label: Toggle to perform BRDF correction
    doc: |
      Indicates whether BRDF correction shall be performed. If True, output is nadir BRDF adjusted reflectance instead
      of BOA reflectance (the output is named BOA nonetheless). Default: True
  do_multi_scattering:
    type: boolean?
    label: Toggle to perform multiple scattering approximation for radiative transfer calculations
    doc: |
      Indicates whether multiple scattering (True) or the single scattering approximation (False)
      shall be used in the radiative transfer calculations. Default: True
  do_topo:
    type: boolean?
    label: Toggle to perform topographic correction
    doc: |
      Indicates whether topographic correction shall be performed. If True, a DEM need to be named. Default: True
  erase_clouds:
    type: boolean?
    label: Toggle to erase cloud detections in the reflectance product
    doc: |
      Indicates whether confident cloud detections will be erased in the reflectance product, i.e. pixels are set to nodata.
      The cloud flag in the QAI product will still mark these pixels as clouds. Use this option if disk space is of concern. Default: False
  impulse_noise:
    type: boolean?
    label: Toggle to remove impulse noise
    doc: |
      Defines whether impulse noise should be removed. Only applies to 8bit input data. Default: True
  max_cloud_cover_frame:
    type: float?
    label: Threshold for cloud cover per image
    doc: |
      indicates whether to cancel processing of images that exceed the given threshold.
      The processing will be canceled after cloud detection. Example: 99 . Default: 99
  max_cloud_cover_tile:
    type: float?
    label: Threshold for cloud cover per chip
    doc: |
      This parameter works on a tile basis. It suppresses the output for chips (tiled image) that exceed the given threshold.
      Example: 99 . Default: 99
  name:
    type: string?
    label: Production name
    doc: |
      Name of the datacube. Example: bologna . Default: cube-
      The name of the resulting STAC item is based on this name
  origin_lat:
    type: float?
    label: Origin latitude coordinate of the grid system in decimal degree
    doc: |
      Origin coordinate of the grid system in decimal degree (negative values for West/South).
      The upper left corner of tile X0000_Y0000 represents this point. It is a good choice to use a coordinate that is
      North-West of your study area – to avoid negative tile numbers. Not used if projection is one of the predefined projections.
      Default: 60.0
  origin_lon:
    type: float?
    label: Origin longitude coordinate of the grid system in decimal degree
    doc: |
      Origin coordinate of the grid system in decimal degree (negative values for West/South).
      The upper left corner of tile X0000_Y0000 represents this point. It is a good choice to use a coordinate that is
      North-West of your study area – to avoid negative tile numbers. Not used if projection is one of the predefined projections.
      Default: -25.0
  output_aod:
    type: boolean?
    label: Toggle to output Aerosol Optical Depth map for the green band
    doc: |
      Indicates whether to output Aerosol Optical Depth map for the green band.
      No higher-level FORCE module is using this. Default: False
  output_dst:
    type: boolean?
    label: Toggle to output the cloud/cloud shadow/snow distance output
    doc: |
      Indicates whether to output the cloud/cloud shadow/snow distance output.
      Note that this is NOT the cloud mask (which is sitting in the mandatory QAI product).
      This product can be used in force-level3; no other higher-level FORCE module is using this. Default: False
  output_format:
    type: force-level2-enums.yml#output_format?
    label: Output format
    doc: |
      Output format, which is either uncompressed flat binary image format aka ENVI Standard, GeoTiff, or COG.
      GeoTiff images are compressed with LZW and horizontal differencing; BigTiff support is enabled;
      the Tiff is structured with striped blocks according to the TILE_SIZE (X) and BLOCK_SIZE (Y) specifications.
      Metadata are written to the ENVI header or directly into the Tiff to the FORCE domain. If the size of the metadata
      exceeds the Tiff's limit, an external .aux.xml file is additionally generated. Valid values on CDSE: {GTiff, COG}
  output_hot:
    type: boolean?
    label: Toggle to output the Haze Optimzed Transformation output
    doc: |
      Indicates whether to output the Haze Optimzed Transformation output. This product can be used in force-level3; no other higher-level FORCE module is using this. Default: False
  output_ovv:
    type: boolean?
    label: Toggle to output overview thumbnails
    doc: |
      Indicates whether to output overview thumbnails? These are JPEGs at reduced spatial resolution,
      which feature an RGB overview + quality information overlayed
      (pink: cloud, red: cirrus, cyan: cloud shadow, yellow: snow, orange: saturated, green: subzero reflectance).
      No higher-level FORCE module is using this. Default: False
  output_vzn:
    type: boolean?
    label: Toggle to output the View Zenith map.
    doc: |
      Indicates whether to output the View Zenith map. This product can be used in force-level3;
      no other higher-level FORCE module is using this. Default: False
  output_wvp:
    type: boolean?
    label: Toggle to output the Water Vapor map
    doc: |
      Indicates whether to output the Water Vapor map. No higher-level FORCE module is using this. Default: False
  projection:
    type: string?
    label: Target coordinate system
    doc: |
      Defines the target coordinate system. This projection should ideally be valid for a large geographic extent.
      Two default projection / grid systems are predefined in FORCE: GLANCE7 and EQUI7. They can be specified via
      the projection parameter instead of giving a WKT string. The predefined options have their own settings for
      origin_lat, origin_lon, tile_size, block_size, thus values given as parameters will be ignored.
      EQUI7 consists of 7 Equi-Distant, continental projections with a tile size of 100km.
      GLANCE7 consists of 7 Equal-Area, continental projections, with a tile size of 150km.
      One datacube will be generated for each continent. Else, the projection must be given as WKT string.
      You can verify your projection (and convert to WKT from another format) using gdalsrsinfo. Default: GLANCE7

  res_merge:
    type: force-level2-enums.yml#res_merge?
    label: Method for improving spatial resolution of Sentinel-2's 20 m bands to 10 m
    doc: |
      Defines the method used for improving the spatial resolution of Sentinel-2’s 20 m bands to 10 m.
      Pixels flagged as cloud or shadow will be skipped. Following methods are available: IMPROPHE uses the ImproPhe
      code in a spectral-only setup; REGRESSION uses a multi-parameter regression (results are expected to be best,
      but processing time is significant); STARFM uses a spectral-only setup of the
      Spatial and Temporal Adaptive Reflectance Fusion Model (prediction artifacts may occur between land cover boundaries);
      NONE disables resolution merge; in this case, 20m bands are quadrupled. Default: IMPROPHE
  resampling:
    type: force-level2-enums.yml#resampling?
    label: The resampling option for the reprojection
    doc: |
      The resampling option for the reprojection; you can choose between Nearest Neighbor (NN), Bilinear (BL),
      Cubic Convolution (CC), Cubic Spline (CSP), Lanczos (LZ), Average (AVG), Mode (MODE), Max (MAX), Min (MIN),
      Median (MED), Q1 (Q1), Q3 (Q3), Sum (SUM), and RMS (RMS). Example: NN . Default: CC
  resolution:
    type: int?
    label: Spatial resolution in meters of the FORCE data cube
    doc: |
      Spatial resolution in meters of the FORCE data cube. Example: 10 . Default: 20
  shadow_buffer:
    type: int?
    label: Shadow buffer radius (m)
    doc: |
      Buffer sizes (radius in meters) for cloud shadow masks. Default: 90
  shadow_threshold:
    type: float?
    label: Shadow Threshold of the Fmask algorithm
    doc: |
      Threshold of the Fmask algorithm. Default: 0.02
  snow_buffer:
    type: int?
    label: Snow buffer radius (m)
    doc: |
      Buffer sizes (radius in meters) for snow masks. default: 30
  tile_size:
    type: int?
    label:  Tile size of the gridded output
    doc: |
      Tile size (in target units, commonly in meters) of the gridded output. tiles are square.
      Not used if projection is one of the predefined projections. Default: 30000

steps:
  stringify_stac:
    run:
      cwlVersion: v1.2
      class: ExpressionTool
      requirements:
        InlineJavascriptRequirement: {}
      inputs:
        cfg: Any?
      outputs:
        cfg_json: string
      expression: >
        ${
          if (inputs.cfg === null || inputs.cfg === undefined) {
            return { cfg_json: null };
          } else {
            return { cfg_json: JSON.stringify(inputs.cfg) };
          }
        }
    in:
      cfg: stac_document
    out: [cfg_json]
  staging:
    run: staging.cwl
    in:
      stac_url: stac_url
      stac_string: stringify_stac/cfg_json
      output_path_base:
        default: "staging"
      method:
        default: "recursive"
    out: [staged_root]
  force_level2:
    run: force-l2.cwl
    in:
      input: staging/staged_root
      name: name
      aoi: aoi
      tile_size: tile_size
      block_size: block_size
      origin_lon: origin_lon
      origin_lat: origin_lat
      resolution: resolution
      projection: projection
      resampling: resampling
      dem: dem
      do_atmo: do_atmo
      do_topo: do_topo
      do_brdf: do_brdf
      do_adjacency: do_adjacency
      do_multi_scattering: do_multi_scattering
      do_aod: do_aod
      erase_clouds: erase_clouds
      max_cloud_cover_frame: max_cloud_cover_frame
      max_cloud_cover_tile: max_cloud_cover_tile
      cloud_buffer: cloud_buffer
      cirrus_buffer: cirrus_buffer
      shadow_buffer: shadow_buffer
      snow_buffer: snow_buffer
      cloud_threshold: cloud_threshold
      shadow_threshold: shadow_threshold
      res_merge: res_merge
      impulse_noise: impulse_noise
      buffer_nodata: buffer_nodata
      output_format: output_format
      output_dst: output_dst
      output_aod: output_aod
      output_wvp: output_wvp
      output_vzn: output_vzn
      output_hot: output_hot
      output_ovv: output_ovv
    out: [force_level2_ard]

outputs:
  force_level2_ard:
    type: Directory
    outputSource: force_level2/force_level2_ard