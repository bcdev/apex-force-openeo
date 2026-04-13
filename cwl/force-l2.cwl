cwlVersion: v1.2

# tested with
# ssh yarn@archive03
# cd integration/force/test3
# . /home/yarn/opt/miniconda-cwltool/bin/activate
# export AWS_ENDPOINT_URL_S3='https://eodata.dataspace.copernicus.eu'
# export AWS_ACCESS_KEY_ID=...
# export AWS_SECRET_ACCESS_KEY=...
# cwltool --preserve-environment=AWS_ENDPOINT_URL_S3 --preserve-environment=AWS_ACCESS_KEY_ID --preserve-environment=AWS_SECRET_ACCESS_KEY --force-docker-pull --leave-container --leave-tmpdir --tmpdir-prefix=$HOME/tmp/ material/force-l2.cwl

class: CommandLineTool
requirements:
  NetworkAccess:
     networkAccess: true
  ResourceRequirement:
    ramMin: 8192
    ramMax: 8192
    coresMin: 1
    coresMax: 4
  DockerRequirement:
    dockerPull:
      $include: docker-requirement.yaml

baseCommand: /opt/apex-force-wrapper/bin/force-level2-wrapper.sh
inputs:
  input:
    type: string[]
    inputBinding:
      position: 1
    default:
      - "s3://EODATA/Sentinel-2/MSI/L1C/2024/11/13/S2A_MSIL1C_20241113T101251_N0511_R022_T32TPQ_20241113T121135.SAFE"
#      - "s3://EODATA/Sentinel-2/MSI/L1C/2024/12/28/S2B_MSIL1C_20241228T101339_N0511_R022_T32TPQ_20241228T120532.SAFE"
#      - "s3://EODATA/Sentinel-2/MSI/L1C/2024/12/28/S2B_MSIL1C_20241228T101339_N0511_R022_T32TQQ_20241228T120532.SAFE"
  name:
    type: string?
    inputBinding:
      prefix: --name
  aoi:
    type: string?
    inputBinding:
      prefix: --aoi
#    default: '{ "type": "Feature", "geometry": { "type": "Polygon", "coordinates": [[[10.5,44.0],[10.5,45.0],[11.5,45.0],[11.5,44.0],[10.5,44.0]]] }, "properties": { "name": "Bologna" } }'
  tile_size:
    type: int?
    inputBinding:
      prefix: --tile_size
    default: 30000
  block_size:
    type: int?
    inputBinding:
      prefix: --block_size
    default: 3000
  origin_lon:
    type: float?
    inputBinding:
      prefix: --origin_lon
    default: -25.0
  origin_lat:
    type: float?
    inputBinding:
      prefix: --origin_lat
    default: 60.0
  resolution:
    type: int?
    inputBinding:
      prefix: --resolution
    default: 20
  projection:
    type: string?
    inputBinding:
      prefix: --projection
    default: GLANCE7
  resampling:
    type:
      - "null"
      - type: enum
        symbols:
          - NN
          - BL
          - CC
          - CSP
          - LZ
          - AVG
          - MODE
          - MAX
          - MIN
          - MED
          - Q1
          - Q3
          - SUM
          - RMS
    inputBinding:
      prefix: --resampling
    default: CC
  dem:
    type:
      - "null"
      - type: enum
        symbols:
          - Copernicus_30m
          - none
    inputBinding:
      prefix: --dem
    default: Copernicus_30m
  do_atmo:
    type: boolean?
    inputBinding:
      prefix: --do_atmo
    default: true
  do_topo:
    type: boolean?
    inputBinding:
      prefix: --do_topo
    default: true
  do_brdf:
    type: boolean?
    inputBinding:
      prefix: --do_brdf
    default: true
  do_adjacency:
    type: boolean?
    inputBinding:
      prefix: --do_adjacency
    default: true
  do_multi_scattering:
    type: boolean?
    inputBinding:
      prefix: --do_multi_scattering
    default: true
  do_aod:
    type: boolean?
    inputBinding:
      prefix: --do_aod
    default: true
  erase_clouds:
    type: boolean?
    inputBinding:
      prefix: --erase_clouds
  max_cloud_cover_frame:
    type: float?
    inputBinding:
      prefix: --max_cloud_cover_frame
  max_cloud_cover_tile:
    type: float?
    inputBinding:
      prefix: --max_cloud_cover_tile
  cloud_buffer:
    type: int?
    inputBinding:
      prefix: --cloud_buffer
  cirrus_buffer:
    type: int?
    inputBinding:
      prefix: --cirrus_buffer
  shadow_buffer:
    type: int?
    inputBinding:
      prefix: --shadow_buffer
  snow_buffer:
    type: int?
    inputBinding:
      prefix: --snow_buffer
  cloud_threshold:
    type: float?
    inputBinding:
      prefix: --cloud_threshold
  shadow_threshold:
    type: float?
    inputBinding:
      prefix: --shadow_threshold
  res_merge:
    type:
      - "null"
      - type: enum
        symbols:
          - IMPROPHE
          - REGRESSION
          - STARFM
          - NONE
    inputBinding:
      prefix: --res_merge
    default: IMPROPHE
  impulse_noise:
    type: boolean?
    inputBinding:
      prefix: --impulse_noise
    default: true
  buffer_nodata:
    type: boolean?
    inputBinding:
      prefix: --buffer_nodata
  output_format:
    type:
      - "null"
      - type: enum
        symbols:
          - GTiff
          - COG
    inputBinding:
      prefix: --output_format
  output_dst:
    type: boolean?
    inputBinding:
      prefix: --output_dst
  output_aod:
    type: boolean?
    inputBinding:
      prefix: --output_aod
  output_wvp:
    type: boolean?
    inputBinding:
      prefix: --output_wvp
  output_vzn:
    type: boolean?
    inputBinding:
      prefix: --output_vzn
  output_hot:
    type: boolean?
    inputBinding:
      prefix: --output_hot
  output_ovv:
    type: boolean?
    inputBinding:
      prefix: --output_ovv

outputs:
  ## Alternative with a flat file list, breaks structure
  #force_level2_ard:
  #  type: File[]
  #  outputBinding:
  #    glob: ["*.json", "CITEME*.txt", "*/datacube-definition.prj", "*/*/*tif", "*/*/*jpg"]
  ## Alternative with subdirectory with generated name
  #force_level2_ard1:
  #   type: Directory
  #   outputBinding:
  #     glob: "."
  # Alternative to avoid the additional directory level, but requires to know the subdir name like europe:
  #force_level2_ard1:
  #   type: Directory
  #   outputBinding:
  #     glob: "europe"
  #force_level2_ard2:
  #   type: File[]
  #   outputBinding:
  #     glob: ["*.json", "CITEME*.txt" ]
  # Alternative with a predictable directory name "l2-ard"
  force_level2_ard:
     type: Directory
     outputBinding:
       glob: "l2-ard"
