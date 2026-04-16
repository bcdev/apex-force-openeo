cwlVersion: v1.2
class: Workflow
requirements:
  SchemaDefRequirement:
    types:
      - $import: force-level2-enums.yml
inputs:
  stac_url:
    type: string?
  stac_document:
    type: Any?
  aoi:
    type: string?
  block_size:
    type: int?
  buffer_nodata:
    type: boolean?
  cirrus_buffer:
    type: int?
  cloud_buffer:
    type: int?
  cloud_threshold:
    type: float?
  dem:
    type: force-level2-enums.yml#dem?
  do_adjacency:
    type: boolean?
  do_aod:
    type: boolean?
  do_atmo:
    type: boolean?
  do_brdf:
    type: boolean?
  do_multi_scattering:
    type: boolean?
  do_topo:
    type: boolean?
  erase_clouds:
    type: boolean?
  impulse_noise:
    type: boolean?
  max_cloud_cover_frame:
    type: float?
  max_cloud_cover_tile:
    type: float?
  name:
    type: string?
  origin_lat:
    type: float?
  origin_lon:
    type: float?
  output_aod:
    type: boolean?
  output_dst:
    type: boolean?
  output_format:
    type: force-level2-enums.yml#output_format?
  output_hot:
    type: boolean?
  output_ovv:
    type: boolean?
  output_vzn:
    type: boolean?
  output_wvp:
    type: boolean?
  projection:
    type: string?
  res_merge:
    type: force-level2-enums.yml#res_merge?
  resampling:
    type: force-level2-enums.yml#resampling?
  resolution:
    type: int?
  shadow_buffer:
    type: int?
  shadow_threshold:
    type: float?
  snow_buffer:
    type: int?
  tile_size:
    type: int?

steps:
  stringify_stac:
    run:
      cwlVersion: v1.2
      class: ExpressionTool
      requirements:
        InlineJavascriptRequirement: {}
      inputs:
        cfg: Any
      outputs:
        cfg_json: string
      expression: >
        ${ return { cfg_json: JSON.stringify(inputs.cfg) }; }
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