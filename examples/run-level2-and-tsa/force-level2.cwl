{
    "$graph": [
        {
            "class": "Workflow",
            "requirements": [
                {
                    "class": "InlineJavascriptRequirement"
                },
                {
                    "types": [
                        {
                            "type": "enum",
                            "name": "#force-level2-enums.yml/resampling",
                            "label": "Resampling option for reprojection",
                            "symbols": [
                                "#force-level2-enums.yml/resampling/NN",
                                "#force-level2-enums.yml/resampling/BL",
                                "#force-level2-enums.yml/resampling/CC",
                                "#force-level2-enums.yml/resampling/CSP",
                                "#force-level2-enums.yml/resampling/LZ",
                                "#force-level2-enums.yml/resampling/AVG",
                                "#force-level2-enums.yml/resampling/MODE",
                                "#force-level2-enums.yml/resampling/MAX",
                                "#force-level2-enums.yml/resampling/MIN",
                                "#force-level2-enums.yml/resampling/MED",
                                "#force-level2-enums.yml/resampling/Q1",
                                "#force-level2-enums.yml/resampling/Q3",
                                "#force-level2-enums.yml/resampling/SUM",
                                "#force-level2-enums.yml/resampling/RMS"
                            ]
                        },
                        {
                            "type": "enum",
                            "name": "#force-level2-enums.yml/dem",
                            "label": "Digital Elevation Model",
                            "symbols": [
                                "#force-level2-enums.yml/dem/Copernicus_30m",
                                "#force-level2-enums.yml/dem/NONE"
                            ]
                        },
                        {
                            "type": "enum",
                            "name": "#force-level2-enums.yml/res_merge",
                            "label": "Method used for improving the spatial resolution of Sentinel-2's 20 m bands to 10 m.",
                            "symbols": [
                                "#force-level2-enums.yml/res_merge/IMPROPHE",
                                "#force-level2-enums.yml/res_merge/REGRESSION",
                                "#force-level2-enums.yml/res_merge/STARFM",
                                "#force-level2-enums.yml/res_merge/NONE"
                            ]
                        },
                        {
                            "type": "enum",
                            "name": "#force-level2-enums.yml/output_format",
                            "label": "Output Format",
                            "symbols": [
                                "#force-level2-enums.yml/output_format/GTiff",
                                "#force-level2-enums.yml/output_format/COG"
                            ]
                        }
                    ],
                    "class": "SchemaDefRequirement"
                }
            ],
            "inputs": [
                {
                    "type": [
                        "null",
                        "string"
                    ],
                    "id": "#main/aoi"
                },
                {
                    "type": [
                        "null",
                        "int"
                    ],
                    "id": "#main/block_size"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "id": "#main/buffer_nodata"
                },
                {
                    "type": [
                        "null",
                        "int"
                    ],
                    "id": "#main/cirrus_buffer"
                },
                {
                    "type": [
                        "null",
                        "int"
                    ],
                    "id": "#main/cloud_buffer"
                },
                {
                    "type": [
                        "null",
                        "float"
                    ],
                    "id": "#main/cloud_threshold"
                },
                {
                    "type": [
                        "null",
                        "#force-level2-enums.yml/dem"
                    ],
                    "id": "#main/dem"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "id": "#main/do_adjacency"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "id": "#main/do_aod"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "id": "#main/do_atmo"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "id": "#main/do_brdf"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "id": "#main/do_multi_scattering"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "id": "#main/do_topo"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "id": "#main/erase_clouds"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "id": "#main/impulse_noise"
                },
                {
                    "type": [
                        "null",
                        "float"
                    ],
                    "id": "#main/max_cloud_cover_frame"
                },
                {
                    "type": [
                        "null",
                        "float"
                    ],
                    "id": "#main/max_cloud_cover_tile"
                },
                {
                    "type": [
                        "null",
                        "string"
                    ],
                    "id": "#main/name"
                },
                {
                    "type": [
                        "null",
                        "float"
                    ],
                    "id": "#main/origin_lat"
                },
                {
                    "type": [
                        "null",
                        "float"
                    ],
                    "id": "#main/origin_lon"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "id": "#main/output_aod"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "id": "#main/output_dst"
                },
                {
                    "type": [
                        "null",
                        "#force-level2-enums.yml/output_format"
                    ],
                    "id": "#main/output_format"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "id": "#main/output_hot"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "id": "#main/output_ovv"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "id": "#main/output_vzn"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "id": "#main/output_wvp"
                },
                {
                    "type": [
                        "null",
                        "string"
                    ],
                    "id": "#main/projection"
                },
                {
                    "type": [
                        "null",
                        "#force-level2-enums.yml/res_merge"
                    ],
                    "id": "#main/res_merge"
                },
                {
                    "type": [
                        "null",
                        "#force-level2-enums.yml/resampling"
                    ],
                    "id": "#main/resampling"
                },
                {
                    "type": [
                        "null",
                        "int"
                    ],
                    "id": "#main/resolution"
                },
                {
                    "type": [
                        "null",
                        "int"
                    ],
                    "id": "#main/shadow_buffer"
                },
                {
                    "type": [
                        "null",
                        "float"
                    ],
                    "id": "#main/shadow_threshold"
                },
                {
                    "type": [
                        "null",
                        "int"
                    ],
                    "id": "#main/snow_buffer"
                },
                {
                    "type": [
                        "null",
                        "Any"
                    ],
                    "id": "#main/stac_document"
                },
                {
                    "type": [
                        "null",
                        "string"
                    ],
                    "id": "#main/stac_url"
                },
                {
                    "type": [
                        "null",
                        "int"
                    ],
                    "id": "#main/tile_size"
                }
            ],
            "steps": [
                {
                    "run": "#force-l2.cwl",
                    "in": [
                        {
                            "source": "#main/aoi",
                            "id": "#main/force_level2/aoi"
                        },
                        {
                            "source": "#main/block_size",
                            "id": "#main/force_level2/block_size"
                        },
                        {
                            "source": "#main/buffer_nodata",
                            "id": "#main/force_level2/buffer_nodata"
                        },
                        {
                            "source": "#main/cirrus_buffer",
                            "id": "#main/force_level2/cirrus_buffer"
                        },
                        {
                            "source": "#main/cloud_buffer",
                            "id": "#main/force_level2/cloud_buffer"
                        },
                        {
                            "source": "#main/cloud_threshold",
                            "id": "#main/force_level2/cloud_threshold"
                        },
                        {
                            "source": "#main/dem",
                            "id": "#main/force_level2/dem"
                        },
                        {
                            "source": "#main/do_adjacency",
                            "id": "#main/force_level2/do_adjacency"
                        },
                        {
                            "source": "#main/do_aod",
                            "id": "#main/force_level2/do_aod"
                        },
                        {
                            "source": "#main/do_atmo",
                            "id": "#main/force_level2/do_atmo"
                        },
                        {
                            "source": "#main/do_brdf",
                            "id": "#main/force_level2/do_brdf"
                        },
                        {
                            "source": "#main/do_multi_scattering",
                            "id": "#main/force_level2/do_multi_scattering"
                        },
                        {
                            "source": "#main/do_topo",
                            "id": "#main/force_level2/do_topo"
                        },
                        {
                            "source": "#main/erase_clouds",
                            "id": "#main/force_level2/erase_clouds"
                        },
                        {
                            "source": "#main/impulse_noise",
                            "id": "#main/force_level2/impulse_noise"
                        },
                        {
                            "source": "#main/staging/staged_root",
                            "id": "#main/force_level2/input"
                        },
                        {
                            "source": "#main/max_cloud_cover_frame",
                            "id": "#main/force_level2/max_cloud_cover_frame"
                        },
                        {
                            "source": "#main/max_cloud_cover_tile",
                            "id": "#main/force_level2/max_cloud_cover_tile"
                        },
                        {
                            "source": "#main/name",
                            "id": "#main/force_level2/name"
                        },
                        {
                            "source": "#main/origin_lat",
                            "id": "#main/force_level2/origin_lat"
                        },
                        {
                            "source": "#main/origin_lon",
                            "id": "#main/force_level2/origin_lon"
                        },
                        {
                            "source": "#main/output_aod",
                            "id": "#main/force_level2/output_aod"
                        },
                        {
                            "source": "#main/output_dst",
                            "id": "#main/force_level2/output_dst"
                        },
                        {
                            "source": "#main/output_format",
                            "id": "#main/force_level2/output_format"
                        },
                        {
                            "source": "#main/output_hot",
                            "id": "#main/force_level2/output_hot"
                        },
                        {
                            "source": "#main/output_ovv",
                            "id": "#main/force_level2/output_ovv"
                        },
                        {
                            "source": "#main/output_vzn",
                            "id": "#main/force_level2/output_vzn"
                        },
                        {
                            "source": "#main/output_wvp",
                            "id": "#main/force_level2/output_wvp"
                        },
                        {
                            "source": "#main/projection",
                            "id": "#main/force_level2/projection"
                        },
                        {
                            "source": "#main/res_merge",
                            "id": "#main/force_level2/res_merge"
                        },
                        {
                            "source": "#main/resampling",
                            "id": "#main/force_level2/resampling"
                        },
                        {
                            "source": "#main/resolution",
                            "id": "#main/force_level2/resolution"
                        },
                        {
                            "source": "#main/shadow_buffer",
                            "id": "#main/force_level2/shadow_buffer"
                        },
                        {
                            "source": "#main/shadow_threshold",
                            "id": "#main/force_level2/shadow_threshold"
                        },
                        {
                            "source": "#main/snow_buffer",
                            "id": "#main/force_level2/snow_buffer"
                        },
                        {
                            "source": "#main/tile_size",
                            "id": "#main/force_level2/tile_size"
                        }
                    ],
                    "out": [
                        "#main/force_level2/force_level2_ard"
                    ],
                    "id": "#main/force_level2"
                },
                {
                    "run": "#staging.cwl",
                    "in": [
                        {
                            "default": "recursive",
                            "id": "#main/staging/method"
                        },
                        {
                            "default": "staging",
                            "id": "#main/staging/output_path_base"
                        },
                        {
                            "source": "#main/stringify_stac/cfg_json",
                            "id": "#main/staging/stac_string"
                        },
                        {
                            "source": "#main/stac_url",
                            "id": "#main/staging/stac_url"
                        }
                    ],
                    "out": [
                        "#main/staging/staged_root"
                    ],
                    "id": "#main/staging"
                },
                {
                    "run": {
                        "cwlVersion": "v1.2",
                        "class": "ExpressionTool",
                        "requirements": [
                            {
                                "class": "InlineJavascriptRequirement"
                            }
                        ],
                        "inputs": [
                            {
                                "type": [
                                    "null",
                                    "Any"
                                ],
                                "id": "#main/stringify_stac/run/cfg"
                            }
                        ],
                        "outputs": [
                            {
                                "type": "string",
                                "id": "#main/stringify_stac/run/cfg_json"
                            }
                        ],
                        "expression": "${\n  if (inputs.cfg === null || inputs.cfg === undefined) {\n    return { cfg_json: null };\n  } else {\n    return { cfg_json: JSON.stringify(inputs.cfg) }; \n  }\n}\n"
                    },
                    "in": [
                        {
                            "source": "#main/stac_document",
                            "id": "#main/stringify_stac/cfg"
                        }
                    ],
                    "out": [
                        "#main/stringify_stac/cfg_json"
                    ],
                    "id": "#main/stringify_stac"
                }
            ],
            "id": "#main",
            "outputs": [
                {
                    "type": "Directory",
                    "outputSource": "#main/force_level2/force_level2_ard",
                    "id": "#main/force_level2_ard"
                }
            ]
        },
        {
            "class": "CommandLineTool",
            "requirements": [
                {
                    "dockerPull": "quay.io/bcdev/force-eoap:0.5.1",
                    "class": "DockerRequirement"
                },
                {
                    "networkAccess": true,
                    "class": "NetworkAccess"
                },
                {
                    "ramMin": 8192,
                    "ramMax": 8192,
                    "coresMin": 1,
                    "coresMax": 4,
                    "class": "ResourceRequirement"
                },
                {
                    "types": [
                        {
                            "$import": "#force-level2-enums.yml/resampling"
                        },
                        {
                            "$import": "#force-level2-enums.yml/dem"
                        },
                        {
                            "$import": "#force-level2-enums.yml/res_merge"
                        },
                        {
                            "$import": "#force-level2-enums.yml/output_format"
                        }
                    ],
                    "class": "SchemaDefRequirement"
                }
            ],
            "baseCommand": "/opt/apex-force-wrapper/bin/force-level2-wrapper.sh",
            "inputs": [
                {
                    "type": [
                        "null",
                        "string"
                    ],
                    "inputBinding": {
                        "prefix": "--aoi"
                    },
                    "id": "#force-l2.cwl/aoi"
                },
                {
                    "type": [
                        "null",
                        "int"
                    ],
                    "inputBinding": {
                        "prefix": "--block_size"
                    },
                    "default": 3000,
                    "id": "#force-l2.cwl/block_size"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "inputBinding": {
                        "prefix": "--buffer_nodata"
                    },
                    "id": "#force-l2.cwl/buffer_nodata"
                },
                {
                    "type": [
                        "null",
                        "int"
                    ],
                    "inputBinding": {
                        "prefix": "--cirrus_buffer"
                    },
                    "id": "#force-l2.cwl/cirrus_buffer"
                },
                {
                    "type": [
                        "null",
                        "int"
                    ],
                    "inputBinding": {
                        "prefix": "--cloud_buffer"
                    },
                    "id": "#force-l2.cwl/cloud_buffer"
                },
                {
                    "type": [
                        "null",
                        "float"
                    ],
                    "inputBinding": {
                        "prefix": "--cloud_threshold"
                    },
                    "id": "#force-l2.cwl/cloud_threshold"
                },
                {
                    "type": [
                        "null",
                        "#force-level2-enums.yml/dem"
                    ],
                    "inputBinding": {
                        "prefix": "--dem"
                    },
                    "default": "Copernicus_30m",
                    "id": "#force-l2.cwl/dem"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "inputBinding": {
                        "prefix": "--do_adjacency"
                    },
                    "default": true,
                    "id": "#force-l2.cwl/do_adjacency"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "inputBinding": {
                        "prefix": "--do_aod"
                    },
                    "default": true,
                    "id": "#force-l2.cwl/do_aod"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "inputBinding": {
                        "prefix": "--do_atmo"
                    },
                    "default": true,
                    "id": "#force-l2.cwl/do_atmo"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "inputBinding": {
                        "prefix": "--do_brdf"
                    },
                    "default": true,
                    "id": "#force-l2.cwl/do_brdf"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "inputBinding": {
                        "prefix": "--do_multi_scattering"
                    },
                    "default": true,
                    "id": "#force-l2.cwl/do_multi_scattering"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "inputBinding": {
                        "prefix": "--do_topo"
                    },
                    "default": true,
                    "id": "#force-l2.cwl/do_topo"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "inputBinding": {
                        "prefix": "--erase_clouds"
                    },
                    "id": "#force-l2.cwl/erase_clouds"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "inputBinding": {
                        "prefix": "--impulse_noise"
                    },
                    "default": true,
                    "id": "#force-l2.cwl/impulse_noise"
                },
                {
                    "type": "Directory",
                    "inputBinding": {
                        "prefix": "--inputs"
                    },
                    "id": "#force-l2.cwl/input"
                },
                {
                    "type": [
                        "null",
                        "float"
                    ],
                    "inputBinding": {
                        "prefix": "--max_cloud_cover_frame"
                    },
                    "id": "#force-l2.cwl/max_cloud_cover_frame"
                },
                {
                    "type": [
                        "null",
                        "float"
                    ],
                    "inputBinding": {
                        "prefix": "--max_cloud_cover_tile"
                    },
                    "id": "#force-l2.cwl/max_cloud_cover_tile"
                },
                {
                    "type": [
                        "null",
                        "string"
                    ],
                    "inputBinding": {
                        "prefix": "--name"
                    },
                    "id": "#force-l2.cwl/name"
                },
                {
                    "type": [
                        "null",
                        "float"
                    ],
                    "inputBinding": {
                        "prefix": "--origin_lat"
                    },
                    "default": 60.0,
                    "id": "#force-l2.cwl/origin_lat"
                },
                {
                    "type": [
                        "null",
                        "float"
                    ],
                    "inputBinding": {
                        "prefix": "--origin_lon"
                    },
                    "default": -25.0,
                    "id": "#force-l2.cwl/origin_lon"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "inputBinding": {
                        "prefix": "--output_aod"
                    },
                    "id": "#force-l2.cwl/output_aod"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "inputBinding": {
                        "prefix": "--output_dst"
                    },
                    "id": "#force-l2.cwl/output_dst"
                },
                {
                    "type": [
                        "null",
                        "#force-level2-enums.yml/output_format"
                    ],
                    "inputBinding": {
                        "prefix": "--output_format"
                    },
                    "id": "#force-l2.cwl/output_format"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "inputBinding": {
                        "prefix": "--output_hot"
                    },
                    "id": "#force-l2.cwl/output_hot"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "inputBinding": {
                        "prefix": "--output_ovv"
                    },
                    "id": "#force-l2.cwl/output_ovv"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "inputBinding": {
                        "prefix": "--output_vzn"
                    },
                    "id": "#force-l2.cwl/output_vzn"
                },
                {
                    "type": [
                        "null",
                        "boolean"
                    ],
                    "inputBinding": {
                        "prefix": "--output_wvp"
                    },
                    "id": "#force-l2.cwl/output_wvp"
                },
                {
                    "type": [
                        "null",
                        "string"
                    ],
                    "inputBinding": {
                        "prefix": "--projection"
                    },
                    "default": "GLANCE7",
                    "id": "#force-l2.cwl/projection"
                },
                {
                    "type": [
                        "null",
                        "#force-level2-enums.yml/res_merge"
                    ],
                    "inputBinding": {
                        "prefix": "--res_merge"
                    },
                    "default": "IMPROPHE",
                    "id": "#force-l2.cwl/res_merge"
                },
                {
                    "type": [
                        "null",
                        "#force-level2-enums.yml/resampling"
                    ],
                    "inputBinding": {
                        "prefix": "--resampling"
                    },
                    "default": "CC",
                    "id": "#force-l2.cwl/resampling"
                },
                {
                    "type": [
                        "null",
                        "int"
                    ],
                    "inputBinding": {
                        "prefix": "--resolution"
                    },
                    "default": 20,
                    "id": "#force-l2.cwl/resolution"
                },
                {
                    "type": [
                        "null",
                        "int"
                    ],
                    "inputBinding": {
                        "prefix": "--shadow_buffer"
                    },
                    "id": "#force-l2.cwl/shadow_buffer"
                },
                {
                    "type": [
                        "null",
                        "float"
                    ],
                    "inputBinding": {
                        "prefix": "--shadow_threshold"
                    },
                    "id": "#force-l2.cwl/shadow_threshold"
                },
                {
                    "type": [
                        "null",
                        "int"
                    ],
                    "inputBinding": {
                        "prefix": "--snow_buffer"
                    },
                    "id": "#force-l2.cwl/snow_buffer"
                },
                {
                    "type": [
                        "null",
                        "int"
                    ],
                    "inputBinding": {
                        "prefix": "--tile_size"
                    },
                    "default": 30000,
                    "id": "#force-l2.cwl/tile_size"
                }
            ],
            "outputs": [
                {
                    "type": "Directory",
                    "outputBinding": {
                        "glob": "l2-ard"
                    },
                    "id": "#force-l2.cwl/force_level2_ard"
                }
            ],
            "id": "#force-l2.cwl"
        },
        {
            "class": "CommandLineTool",
            "requirements": [
                {
                    "dockerPull": "quay.io/bcdev/force-eoap:0.5.1",
                    "class": "DockerRequirement"
                },
                {
                    "networkAccess": true,
                    "class": "NetworkAccess"
                }
            ],
            "baseCommand": "/opt/uv/uv",
            "arguments": [
                "run",
                "--no-sync",
                "--project",
                "/opt/force-python-tools",
                "download-stac"
            ],
            "inputs": [
                {
                    "type": [
                        "null",
                        "string"
                    ],
                    "inputBinding": {
                        "prefix": "--method"
                    },
                    "default": "ASSET",
                    "id": "#staging.cwl/method"
                },
                {
                    "type": "string",
                    "inputBinding": {
                        "prefix": "--output-path"
                    },
                    "id": "#staging.cwl/output_path_base"
                },
                {
                    "type": [
                        "null",
                        "string"
                    ],
                    "inputBinding": {
                        "prefix": "--string"
                    },
                    "id": "#staging.cwl/stac_string"
                },
                {
                    "type": [
                        "null",
                        "string"
                    ],
                    "inputBinding": {
                        "prefix": "--url"
                    },
                    "id": "#staging.cwl/stac_url"
                }
            ],
            "outputs": [
                {
                    "type": "Directory",
                    "outputBinding": {
                        "glob": "$(inputs.output_path_base)"
                    },
                    "id": "#staging.cwl/staged_root"
                }
            ],
            "id": "#staging.cwl"
        }
    ],
    "cwlVersion": "v1.2"
}
