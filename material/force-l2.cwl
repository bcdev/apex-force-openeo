cwlVersion: v1.2
$namespaces:
  s: https://schema.org/
s:softwareVersion: 1.0.0
schemas:
  - http://schema.org/version/9.0/schemaorg-current-http.rdf
$graph:
  - class: Workflow
    label: FORCE Level 2
    doc: Preprocessing Sentinel-2 with FORCE
    id: force-level2
    requirements: []
    inputs:
      input:
        type: Directory
        label: Input S2 L1C
        loadListing: no_listing
      aoi:
        type: string
        label: area of interest as bounding box or polygon WKT
        doc: Clipping polygon
      resolution:
        type: int
        label: Resolution
        doc: Resolution in metres
        default: 20
      projection:
        type:
          type: enum
          symbols:
            - GLANCE7
            - EQUI7
        label: projection
        doc: predefined projection of the target grid
        default: GLANCE7
      resampling:
        type:
          type: enum
          symbols:
            - NN
            - BL
            - CC
        label: resampling
        doc: nearest neighbour, bi-linear, or cubic convolution
        default: CC
      dem:
        type:
          type: enum
          symbols:
            - Copernicus_90m
            - Copernicus_30m
            - none
        label: Digital elevation model
        doc: DEM to be used with topographic correction
        default: Copernicus_90m
      do_atmo:
        type: bool
        label: atmospheric correction
        doc: whether to apply AC or to pass through the L1C
        default: true
      do_topo:
        type: bool
        label: topographic correction
        doc: whether to apply topographic correction
        default: true
      do_brdf:
        type: bool
        label: brdf correction
        doc: whether to apply BRDF
        default: true
      do_adjacency:
        type: bool
        label: adjacency effect correction
        doc: whether to apply adjacency effect correction
        default: true
      do_multi_scattering:
        type: bool
        label: multiple scattering
        doc: whether to apply multiple scattering or single scattering in radiative transfer calculations
        default: true
      do_aod:
        type: bool
        label: estimate AOD
        doc: whether to estimate AOD
        default: true
      erase_clouds:
        type: bool
        label: mask cloud pixels
        doc: set pixels affected by clouds to to nodata
        default: false
      max_cloud_cover_frame
        type: float
        label: cloud cover threshold
        doc: drop inputs with cloud cover larger than threshold
        default: 99
      max_cloud_cover_tile
        type: float
        label: cloud cover threshold
        doc: drop output tiles with cloud cover larger than threshold
        default: 99
      cloud_buffer:
        type: int
        label: cloud buffer
        doc: cloud buffer width in meters
        default: 300
      cirrus_buffer:
        type: int
        label: cloud buffer
        doc: cirrus buffer width in meters
        default: 0
      shadow_buffer:
        type: int
        label: cloud shadow buffer
        doc: cloud shadow buffer width in meters
        default: 90
      snow_buffer:
        type: int
        label: snow buffer
        doc: snow buffer width in meters
        default: 30
      cloud_threshold:
        type: float
        label: cloud threshold
        doc: fmask cloud threshold
        default: 0.225
      shadow_threshold:
        type: float
        label: shadow threshold
        doc: fmask shadow threshold value
        default: 0.02
      res_merge:
        type:
          type: enum
          symbols:
            - IMPROPHE
            - REGRESSION
            - STARFM
            - NONE
        label: resolution merging
        doc: method to improve resolution to 10m
        default: IMPROPHE
      impulse_noise:
        type: bool
        label: remove impulse noise
        doc: whether to remove impulse noise from 8-bit data variables
        default: true
      buffer_nodata:
        type: bool
        label: buffer nodata pixels
        doc: whether to buffer nodata pixels by 1 pixel
        default: false
      nproc:
        type: int
        label: number of processes
        doc: number of images processsed concurrently
        default: 3
      nthread:
        type: int
        label: number of threads
        doc: number of threads per process
        default: 4
      parallel_reads:
        type: bool
        label: use parallel reads
        doc: read different variables of a single input concurrently (if the driver does not do so anyway)
        default: false
      process_start_delay:
        type: int
        label: seconds to wait before starting a child process
        doc: delay to avoid i/o jams
        default: 3
      timeout_zip:
        type: int
        label: seconds to wait until unpacking is aborted
        doc: monitoring unpacking of the input
        default: 30
      output_format:
        type:
          type: enum
          symbols:
            - GTiff
            - COG
         label: output format
         doc: output file format
         default: GTiff
      output_dst:
        type: bool
        label: output distance to cloud
        doc: whether to output DST
        default: false
      output_aod:
        type: bool
        label: output atmospheric optical depth
        doc: whether to output AOD
        default: false
      output_wvp:
        type: bool
        label: output water vapour
        doc: whether to output WVP
        default: false
      output_vzn:
        type: bool
        label: output view zenith angles
        doc: whether to output VZN
        default: false
      output_hot:
        type: bool
        label: output haze optimised transformation output
        doc: whether to output HOT
        default: false
      output_ovv:
        type: bool
        label: output cloud mask quicklook
        doc: whether to output an overview image
        default: true
    outputs:
      - id: stac_catalog
        outputSource:
          - run_script/force-level2_wrapper
        type: Directory

    steps:
      run_script:
        run: "#force_level2_wrapper"
        in:
          input: input
          aoi: aoi
          resolution: resolution
          projection: projection
          resampling: resampling
          dem: dem
          do_atmo: do_atmo
          do_topo: do_topo
          do-brdf: do_brdf
          do_adjacency: do_adjacency
          do_multi_scattering do_multi_scattering
          do_aod do_aod
          erase_clouds erase_clouds
          max_cloud_cover_frame max_cloud_cover_frame
          max_cloud_cover_tile max_cloud_cover_tile
          cloud_buffer: cloud_buffer
          cirrus_buffer: cirrus_buffer
          shadow_buffer: shadow_buffer
          snow_buffer: snow_buffer
          cloud_threshold: cloud_threshold
          shadow_threshold: shadow_threshold
          res_merge: res_merge
          impulse_noise: impulse_noise
          buffer_nodata: buffer_nodata
          nproc: nproc
          nthread: nthread
          parallel_reads: parallel_reads
          process_start_delay: process_start_delay
          timeout_zip: timeout_zip
          output_format: output_format
          output_dst: output_dst
          output_dst: output_dst
          output_aod: output_aod
          output_wvp: output_wvp
          output_vzn: output_vzn
          output_hot: output_hot
          output_ovv: output_ovv
        out:
          - force_ard

  - class: CommandLineTool
    id: force_level2_wrapper
    requirements:
      DockerRequirement:
        dockerPull: quay.io/bcdev/force-openeo:1.0
      NetworkAccess:
        networkAccess: true

    baseCommand:
      - force_level2_wrapper.sh
    inputs:
      input:
        type: Directory
        inputBinding:
          position: 1
      aoi:
        type: str
        inputBinding:
          prefix: --aoi
      resolution:
        type: int
        inputBinding:
          prefix: --resolution
      projection:
        type:
          type: enum
          symbols:
            - GLANCE7
            - EQUI7
        inputBinding:
          prefix: --projection
      resampling:
        type:
          type: enum
          symbols:
            - NN
            - BL
            - CC
        inputBinding:
          prefix: --resampling
      dem:
        type:
          type: enum
          symbols:
            - Copernicus_90m
            - Copernicus_30m
            - none
        inputBinding:
          prefix: --dem
      do_atmo:
        type: bool
        inputBinding:
          prefix: --do_atmo
      do_topo:
        type: bool
        inputBinding:
          prefix: --do_topo
      do_brdf:
        type: bool
        inputBinding:
          prefix: --do_brdf
      do_adjacency:
        type: bool
        inputBinding:
          prefix: --do_adjacency
      do_multi_scattering:
        type: bool
        inputBinding:
          prefix: --do_multi_scattering
      do_aod:
        type: bool
        inputBinding:
          prefix: --do_aod
      erase_clouds:
        type: bool
        inputBinding:
          prefix: --erase_clouds
      max_cloud_cover_frame
        type: float
        inputBinding:
          prefix: - max_cloud_cover_frame
      max_cloud_cover_tile
        type: float
        inputBinding:
          prefix: --max_cloud_cover_tile
      cloud_buffer:
        type: int
        inputBinding:
          prefix: --cloud_buffer
      cirrus_buffer:
        type: int
        inputBinding:
          prefix: --cirrus_buffer
      shadow_buffer:
        type: int
        inputBinding:
          prefix: --shadow_buffer
      snow_buffer:
        type: int
        inputBinding:
          prefix: --snow_buffer
      cloud_threshold:
        type: float
        inputBinding:
          prefix: --cloud_threshold
      shadow_threshold:
        type: float
        inputBinding:
          prefix: --shadow_threshold
      res_merge:
        type:
          type: enum
          symbols:
            - IMPROPHE
            - REGRESSION
            - STARFM
            - NONE
        inputBinding:
          prefix: --res_merge
      impulse_noise:
        type: bool
        inputBinding:
          prefix: --impulse_noise
      buffer_nodata:
        type: bool
        inputBinding:
          prefix: --buffer_nodata
      nproc:
        type: int
        inputBinding:
          prefix: --nproc
      nthread:
        type: int
        inputBinding:
          prefix: --nthread
      parallel_reads:
        type: bool
        inputBinding:
          prefix: --parallel_reads
      process_start_delay:
        type: int
        inputBinding:
          prefix: --process_start_delay
      timeout_zip:
        type: int
        inputBinding:
          prefix: --timeout_zip
      output_format:
        type:
          type: enum
          symbols:
            - GTiff
            - COG
        inputBinding:
          prefix: --output_format
      output_dst:
        type: bool
        inputBinding:
          prefix: --output_dst
      output_aod:
        type: bool
        inputBinding:
          prefix: --output_aod
      output_wvp:
        type: bool
        inputBinding:
          prefix: --output_wvp
      output_vzn:
        type: bool
        inputBinding:
          prefix: --output_vzn
      output_hot:
        type: bool
        inputBinding:
          prefix: --output_hot
      output_ovv:
        type: bool
        inputBinding:
          prefix: --output_ovv

    outputs:
      force_level2_ard:
        outputBinding:
          glob: .
        type: Directory
