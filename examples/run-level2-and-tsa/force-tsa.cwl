{
    "$graph": [
        {
            "class": "Workflow",
            "requirements": [
                {
                    "types": [
                        {
                            "type": "enum",
                            "name": "#force-enums.yml/sensors_type",
                            "label": "Sensor or identifier for sensor combination",
                            "symbols": [
                                "#force-enums.yml/sensors_type/SEN2A",
                                "#force-enums.yml/sensors_type/SEN2B",
                                "#force-enums.yml/sensors_type/SEN2C",
                                "#force-enums.yml/sensors_type/SEN2L"
                            ]
                        },
                        {
                            "type": "enum",
                            "name": "#force-enums.yml/screen_qai_type",
                            "label": "Quality flag",
                            "symbols": [
                                "#force-enums.yml/screen_qai_type/NODATA",
                                "#force-enums.yml/screen_qai_type/CLOUD_OPAQUE",
                                "#force-enums.yml/screen_qai_type/CLOUD_BUFFER",
                                "#force-enums.yml/screen_qai_type/CLOUD_CIRRUS",
                                "#force-enums.yml/screen_qai_type/CLOUD_SHADOW",
                                "#force-enums.yml/screen_qai_type/SNOW",
                                "#force-enums.yml/screen_qai_type/WATER",
                                "#force-enums.yml/screen_qai_type/AOD_FILL",
                                "#force-enums.yml/screen_qai_type/AOD_HIGH",
                                "#force-enums.yml/screen_qai_type/AOD_INT",
                                "#force-enums.yml/screen_qai_type/SUBZERO",
                                "#force-enums.yml/screen_qai_type/SATURATION",
                                "#force-enums.yml/screen_qai_type/SUN_LOW",
                                "#force-enums.yml/screen_qai_type/ILLUMIN_NONE",
                                "#force-enums.yml/screen_qai_type/ILLUMIN_POOR",
                                "#force-enums.yml/screen_qai_type/ILLUMIN_LOW",
                                "#force-enums.yml/screen_qai_type/SLOPED",
                                "#force-enums.yml/screen_qai_type/WVP_NONE"
                            ]
                        },
                        {
                            "type": "enum",
                            "name": "#force-enums.yml/index_type",
                            "label": "Normalised index or band name",
                            "symbols": [
                                "#force-enums.yml/index_type/B1",
                                "#force-enums.yml/index_type/B2",
                                "#force-enums.yml/index_type/B3",
                                "#force-enums.yml/index_type/B4",
                                "#force-enums.yml/index_type/B5",
                                "#force-enums.yml/index_type/B6",
                                "#force-enums.yml/index_type/B7",
                                "#force-enums.yml/index_type/B8",
                                "#force-enums.yml/index_type/B8A",
                                "#force-enums.yml/index_type/B9",
                                "#force-enums.yml/index_type/B10",
                                "#force-enums.yml/index_type/B11",
                                "#force-enums.yml/index_type/B12",
                                "#force-enums.yml/index_type/SMA",
                                "#force-enums.yml/index_type/NDVI",
                                "#force-enums.yml/index_type/EVI",
                                "#force-enums.yml/index_type/NBR",
                                "#force-enums.yml/index_type/NDTI",
                                "#force-enums.yml/index_type/ARVI",
                                "#force-enums.yml/index_type/SAVI",
                                "#force-enums.yml/index_type/SARVI",
                                "#force-enums.yml/index_type/TC-BRIGHT",
                                "#force-enums.yml/index_type/TC-GREEN",
                                "#force-enums.yml/index_type/TC-WET",
                                "#force-enums.yml/index_type/TC-DI",
                                "#force-enums.yml/index_type/NDBI",
                                "#force-enums.yml/index_type/NDWI",
                                "#force-enums.yml/index_type/MNDWI",
                                "#force-enums.yml/index_type/NDMI",
                                "#force-enums.yml/index_type/NDSI",
                                "#force-enums.yml/index_type/kNDVI",
                                "#force-enums.yml/index_type/NDRE1",
                                "#force-enums.yml/index_type/NDRE2",
                                "#force-enums.yml/index_type/CIre",
                                "#force-enums.yml/index_type/NDVIre1",
                                "#force-enums.yml/index_type/NDVIre2",
                                "#force-enums.yml/index_type/NDVIre3",
                                "#force-enums.yml/index_type/NDVIre1n",
                                "#force-enums.yml/index_type/NDVIre2n",
                                "#force-enums.yml/index_type/NDVIre3n",
                                "#force-enums.yml/index_type/MSRre",
                                "#force-enums.yml/index_type/MSRren",
                                "#force-enums.yml/index_type/CCI",
                                "#force-enums.yml/index_type/EVI2",
                                "#force-enums.yml/index_type/ContRemSWIR"
                            ]
                        },
                        {
                            "type": "enum",
                            "name": "#force-enums.yml/standardize_type",
                            "label": "Normalise mode",
                            "symbols": [
                                "#force-enums.yml/standardize_type/NONE",
                                "#force-enums.yml/standardize_type/NORMALIZE",
                                "#force-enums.yml/standardize_type/CENTER"
                            ]
                        },
                        {
                            "type": "enum",
                            "name": "#force-enums.yml/interpolate_type",
                            "label": "Temporal interpolation method",
                            "symbols": [
                                "#force-enums.yml/interpolate_type/NONE",
                                "#force-enums.yml/interpolate_type/LINEAR",
                                "#force-enums.yml/interpolate_type/MOVING",
                                "#force-enums.yml/interpolate_type/RBF",
                                "#force-enums.yml/interpolate_type/HARMONIC"
                            ]
                        },
                        {
                            "type": "enum",
                            "name": "#force-enums.yml/stm_type",
                            "label": "Spectral temporal metrics aggregator",
                            "symbols": [
                                "#force-enums.yml/stm_type/MIN",
                                "#force-enums.yml/stm_type/Q01",
                                "#force-enums.yml/stm_type/Q05",
                                "#force-enums.yml/stm_type/Q10",
                                "#force-enums.yml/stm_type/Q20",
                                "#force-enums.yml/stm_type/Q25",
                                "#force-enums.yml/stm_type/Q30",
                                "#force-enums.yml/stm_type/Q40",
                                "#force-enums.yml/stm_type/Q50",
                                "#force-enums.yml/stm_type/Q60",
                                "#force-enums.yml/stm_type/Q70",
                                "#force-enums.yml/stm_type/Q75",
                                "#force-enums.yml/stm_type/Q80",
                                "#force-enums.yml/stm_type/Q90",
                                "#force-enums.yml/stm_type/Q95",
                                "#force-enums.yml/stm_type/Q99",
                                "#force-enums.yml/stm_type/MAX",
                                "#force-enums.yml/stm_type/AVG",
                                "#force-enums.yml/stm_type/STD",
                                "#force-enums.yml/stm_type/RNG",
                                "#force-enums.yml/stm_type/IQR",
                                "#force-enums.yml/stm_type/SKW",
                                "#force-enums.yml/stm_type/KRT",
                                "#force-enums.yml/stm_type/NUM",
                                "#force-enums.yml/stm_type/NONE"
                            ]
                        },
                        {
                            "type": "enum",
                            "name": "#force-enums.yml/fold_type_type",
                            "label": "Temporal folding aggregator",
                            "symbols": [
                                "#force-enums.yml/fold_type_type/MIN",
                                "#force-enums.yml/fold_type_type/Q10",
                                "#force-enums.yml/fold_type_type/Q25",
                                "#force-enums.yml/fold_type_type/Q50",
                                "#force-enums.yml/fold_type_type/Q75",
                                "#force-enums.yml/fold_type_type/Q90",
                                "#force-enums.yml/fold_type_type/MAX",
                                "#force-enums.yml/fold_type_type/AVG",
                                "#force-enums.yml/fold_type_type/STD",
                                "#force-enums.yml/fold_type_type/RNG",
                                "#force-enums.yml/fold_type_type/IQR",
                                "#force-enums.yml/fold_type_type/SKW",
                                "#force-enums.yml/fold_type_type/KRT",
                                "#force-enums.yml/fold_type_type/NUM"
                            ]
                        },
                        {
                            "type": "enum",
                            "name": "#force-enums.yml/pol_type",
                            "label": "Polarmetric",
                            "symbols": [
                                "#force-enums.yml/pol_type/DEM",
                                "#force-enums.yml/pol_type/DLM",
                                "#force-enums.yml/pol_type/DPS",
                                "#force-enums.yml/pol_type/DSS",
                                "#force-enums.yml/pol_type/DMS",
                                "#force-enums.yml/pol_type/DES",
                                "#force-enums.yml/pol_type/DEV",
                                "#force-enums.yml/pol_type/DAV",
                                "#force-enums.yml/pol_type/DLV",
                                "#force-enums.yml/pol_type/LTS",
                                "#force-enums.yml/pol_type/LGS",
                                "#force-enums.yml/pol_type/LGV",
                                "#force-enums.yml/pol_type/VEM",
                                "#force-enums.yml/pol_type/VLM",
                                "#force-enums.yml/pol_type/VPS",
                                "#force-enums.yml/pol_type/VSS",
                                "#force-enums.yml/pol_type/VMS",
                                "#force-enums.yml/pol_type/VES",
                                "#force-enums.yml/pol_type/VEV",
                                "#force-enums.yml/pol_type/VAV",
                                "#force-enums.yml/pol_type/VLV",
                                "#force-enums.yml/pol_type/VBL",
                                "#force-enums.yml/pol_type/VGA",
                                "#force-enums.yml/pol_type/VSA",
                                "#force-enums.yml/pol_type/VPA",
                                "#force-enums.yml/pol_type/VGM",
                                "#force-enums.yml/pol_type/VGV",
                                "#force-enums.yml/pol_type/DPY",
                                "#force-enums.yml/pol_type/DPV",
                                "#force-enums.yml/pol_type/IST",
                                "#force-enums.yml/pol_type/IBL",
                                "#force-enums.yml/pol_type/IBT",
                                "#force-enums.yml/pol_type/IGS",
                                "#force-enums.yml/pol_type/IRR",
                                "#force-enums.yml/pol_type/IFR",
                                "#force-enums.yml/pol_type/RAR",
                                "#force-enums.yml/pol_type/RAF",
                                "#force-enums.yml/pol_type/RMR",
                                "#force-enums.yml/pol_type/RMF"
                            ]
                        },
                        {
                            "type": "enum",
                            "name": "#force-enums.yml/trend_tail_type",
                            "label": "Significance testing tail type for trend analysis",
                            "symbols": [
                                "#force-enums.yml/trend_tail_type/LEFT",
                                "#force-enums.yml/trend_tail_type/TWO",
                                "#force-enums.yml/trend_tail_type/RIGHT"
                            ]
                        },
                        {
                            "type": "enum",
                            "name": "#force-enums.yml/output_format_type",
                            "label": "Output file format",
                            "symbols": [
                                "#force-enums.yml/output_format_type/GTiff",
                                "#force-enums.yml/output_format_type/COG"
                            ]
                        }
                    ],
                    "class": "SchemaDefRequirement"
                }
            ],
            "inputs": [
                {
                    "type": "float",
                    "default": 0,
                    "id": "#main/above_noise"
                },
                {
                    "type": "float",
                    "default": 0,
                    "id": "#main/below_noise"
                },
                {
                    "type": "boolean",
                    "default": false,
                    "id": "#main/change_penalty"
                },
                {
                    "type": {
                        "type": "array",
                        "items": "int"
                    },
                    "default": [
                        7500,
                        7500
                    ],
                    "id": "#main/chunk_size"
                },
                {
                    "type": {
                        "type": "array",
                        "items": "string"
                    },
                    "id": "#main/date_range"
                },
                {
                    "type": {
                        "type": "array",
                        "items": "int"
                    },
                    "default": [
                        1,
                        365
                    ],
                    "id": "#main/doy_range"
                },
                {
                    "type": "boolean",
                    "default": false,
                    "id": "#main/fail_if_empty"
                },
                {
                    "type": {
                        "type": "array",
                        "items": "string"
                    },
                    "default": null,
                    "id": "#main/file_tile"
                },
                {
                    "type": {
                        "type": "array",
                        "items": "#force-enums.yml/fold_type_type"
                    },
                    "default": [
                        "AVG"
                    ],
                    "id": "#main/fold_type"
                },
                {
                    "type": {
                        "type": "array",
                        "items": "string"
                    },
                    "default": [
                        "1970-01-01",
                        "2099-01-01"
                    ],
                    "id": "#main/harmonic_fit_range"
                },
                {
                    "type": "int",
                    "default": 3,
                    "id": "#main/harmonic_modes"
                },
                {
                    "type": "boolean",
                    "default": false,
                    "id": "#main/harmonic_trend"
                },
                {
                    "type": {
                        "type": "array",
                        "items": "#force-enums.yml/index_type"
                    },
                    "default": [
                        "NDVI",
                        "EVI",
                        "NBR"
                    ],
                    "id": "#main/index"
                },
                {
                    "type": "int",
                    "default": 16,
                    "id": "#main/int_day"
                },
                {
                    "type": "#force-enums.yml/interpolate_type",
                    "default": "NONE",
                    "id": "#main/interpolate"
                },
                {
                    "type": "int",
                    "default": 16,
                    "id": "#main/moving_max"
                },
                {
                    "type": [
                        "null",
                        "string"
                    ],
                    "id": "#main/name"
                },
                {
                    "type": "boolean",
                    "default": false,
                    "id": "#main/output_cad"
                },
                {
                    "type": "boolean",
                    "default": false,
                    "id": "#main/output_cam"
                },
                {
                    "type": "boolean",
                    "default": false,
                    "id": "#main/output_cao"
                },
                {
                    "type": "boolean",
                    "default": false,
                    "id": "#main/output_caq"
                },
                {
                    "type": "boolean",
                    "default": false,
                    "id": "#main/output_caw"
                },
                {
                    "type": "boolean",
                    "default": false,
                    "id": "#main/output_cay"
                },
                {
                    "type": "boolean",
                    "default": false,
                    "id": "#main/output_explode"
                },
                {
                    "type": "boolean",
                    "default": false,
                    "id": "#main/output_fbd"
                },
                {
                    "type": "boolean",
                    "default": false,
                    "id": "#main/output_fbm"
                },
                {
                    "type": "boolean",
                    "default": false,
                    "id": "#main/output_fbq"
                },
                {
                    "type": "boolean",
                    "default": false,
                    "id": "#main/output_fbw"
                },
                {
                    "type": "boolean",
                    "default": false,
                    "id": "#main/output_fby"
                },
                {
                    "type": "#force-enums.yml/output_format_type",
                    "default": "GTiff",
                    "id": "#main/output_format"
                },
                {
                    "type": "boolean",
                    "default": false,
                    "id": "#main/output_nrt"
                },
                {
                    "type": "boolean",
                    "default": false,
                    "id": "#main/output_pct"
                },
                {
                    "type": "boolean",
                    "default": false,
                    "id": "#main/output_pol"
                },
                {
                    "type": "boolean",
                    "default": false,
                    "id": "#main/output_stm"
                },
                {
                    "type": "boolean",
                    "default": false,
                    "id": "#main/output_trd"
                },
                {
                    "type": "boolean",
                    "default": false,
                    "id": "#main/output_trm"
                },
                {
                    "type": "boolean",
                    "default": false,
                    "id": "#main/output_tro"
                },
                {
                    "type": "boolean",
                    "default": false,
                    "id": "#main/output_trq"
                },
                {
                    "type": "boolean",
                    "default": false,
                    "id": "#main/output_trw"
                },
                {
                    "type": "boolean",
                    "default": false,
                    "id": "#main/output_try"
                },
                {
                    "type": "boolean",
                    "default": false,
                    "id": "#main/output_tsi"
                },
                {
                    "type": "boolean",
                    "default": false,
                    "id": "#main/output_tss"
                },
                {
                    "type": {
                        "type": "array",
                        "items": "#force-enums.yml/pol_type"
                    },
                    "default": [
                        "VSS",
                        "VPS",
                        "VES",
                        "VSA",
                        "RMR",
                        "IGS"
                    ],
                    "id": "#main/pol"
                },
                {
                    "type": "boolean",
                    "default": false,
                    "id": "#main/pol_adaptive"
                },
                {
                    "type": "float",
                    "default": 0.8,
                    "id": "#main/pol_end_threshold"
                },
                {
                    "type": "float",
                    "default": 0.5,
                    "id": "#main/pol_mid_threshold"
                },
                {
                    "type": "float",
                    "default": 0.2,
                    "id": "#main/pol_start_threshold"
                },
                {
                    "type": "string",
                    "default": "BOA",
                    "id": "#main/product_type_main"
                },
                {
                    "type": "string",
                    "default": "QAI",
                    "id": "#main/product_type_quality"
                },
                {
                    "type": "float",
                    "default": 0.95,
                    "id": "#main/rbf_cutoff"
                },
                {
                    "type": {
                        "type": "array",
                        "items": "int"
                    },
                    "default": [
                        8,
                        16,
                        32
                    ],
                    "id": "#main/rbf_sigma"
                },
                {
                    "type": "boolean",
                    "default": false,
                    "id": "#main/reduce_psf"
                },
                {
                    "type": "int",
                    "default": 20,
                    "id": "#main/resolution"
                },
                {
                    "type": {
                        "type": "array",
                        "items": "#force-enums.yml/screen_qai_type"
                    },
                    "default": [
                        "NODATA",
                        "CLOUD_OPAQUE",
                        "CLOUD_BUFFER",
                        "CLOUD_CIRRUS",
                        "CLOUD_SHADOW",
                        "SNOW",
                        "SUBZERO",
                        "SATURATION"
                    ],
                    "id": "#main/screen_qai"
                },
                {
                    "type": {
                        "type": "array",
                        "items": "#force-enums.yml/sensors_type"
                    },
                    "default": [
                        "SEN2A",
                        "SEN2B",
                        "SEN2C"
                    ],
                    "id": "#main/sensors"
                },
                {
                    "type": "boolean",
                    "default": false,
                    "id": "#main/spectral_adjust"
                },
                {
                    "type": [
                        "null",
                        "string"
                    ],
                    "id": "#main/stac_url"
                },
                {
                    "type": "#force-enums.yml/standardize_type",
                    "default": "NONE",
                    "id": "#main/standardize_fold"
                },
                {
                    "type": "#force-enums.yml/standardize_type",
                    "default": "NONE",
                    "id": "#main/standardize_pol"
                },
                {
                    "type": "#force-enums.yml/standardize_type",
                    "default": "NONE",
                    "id": "#main/standardize_tsi"
                },
                {
                    "type": "#force-enums.yml/standardize_type",
                    "default": "NONE",
                    "id": "#main/standardize_tss"
                },
                {
                    "type": {
                        "type": "array",
                        "items": "#force-enums.yml/stm_type"
                    },
                    "default": [
                        "NONE"
                    ],
                    "id": "#main/stm"
                },
                {
                    "type": "#force-enums.yml/sensors_type",
                    "default": "SEN2L",
                    "id": "#main/target_sensor"
                },
                {
                    "type": "float",
                    "default": 0.95,
                    "id": "#main/trend_conf"
                },
                {
                    "type": "#force-enums.yml/trend_tail_type",
                    "default": "TWO",
                    "id": "#main/trend_tail"
                },
                {
                    "type": "boolean",
                    "default": false,
                    "id": "#main/use_l2_improphe"
                },
                {
                    "type": {
                        "type": "array",
                        "items": "int"
                    },
                    "default": [
                        -999,
                        9999
                    ],
                    "id": "#main/x_tile_range"
                },
                {
                    "type": {
                        "type": "array",
                        "items": "int"
                    },
                    "default": [
                        -999,
                        9999
                    ],
                    "id": "#main/y_tile_range"
                }
            ],
            "steps": [
                {
                    "run": "#force-tsa.cwl",
                    "in": [
                        {
                            "source": "#main/above_noise",
                            "id": "#main/force_tsa/above_noise"
                        },
                        {
                            "source": "#main/below_noise",
                            "id": "#main/force_tsa/below_noise"
                        },
                        {
                            "source": "#main/change_penalty",
                            "id": "#main/force_tsa/change_penalty"
                        },
                        {
                            "source": "#main/chunk_size",
                            "id": "#main/force_tsa/chunk_size"
                        },
                        {
                            "source": "#main/date_range",
                            "id": "#main/force_tsa/date_range"
                        },
                        {
                            "source": "#main/doy_range",
                            "id": "#main/force_tsa/doy_range"
                        },
                        {
                            "source": "#main/fail_if_empty",
                            "id": "#main/force_tsa/fail_if_empty"
                        },
                        {
                            "source": "#main/file_tile",
                            "id": "#main/force_tsa/file_tile"
                        },
                        {
                            "source": "#main/fold_type",
                            "id": "#main/force_tsa/fold_type"
                        },
                        {
                            "source": "#main/harmonic_fit_range",
                            "id": "#main/force_tsa/harmonic_fit_range"
                        },
                        {
                            "source": "#main/harmonic_modes",
                            "id": "#main/force_tsa/harmonic_modes"
                        },
                        {
                            "source": "#main/harmonic_trend",
                            "id": "#main/force_tsa/harmonic_trend"
                        },
                        {
                            "source": "#main/index",
                            "id": "#main/force_tsa/index"
                        },
                        {
                            "source": "#main/staging/staged_root",
                            "id": "#main/force_tsa/input_data_dir"
                        },
                        {
                            "source": "#main/int_day",
                            "id": "#main/force_tsa/int_day"
                        },
                        {
                            "source": "#main/interpolate",
                            "id": "#main/force_tsa/interpolate"
                        },
                        {
                            "source": "#main/moving_max",
                            "id": "#main/force_tsa/moving_max"
                        },
                        {
                            "source": "#main/name",
                            "id": "#main/force_tsa/name"
                        },
                        {
                            "source": "#main/output_cad",
                            "id": "#main/force_tsa/output_cad"
                        },
                        {
                            "source": "#main/output_cam",
                            "id": "#main/force_tsa/output_cam"
                        },
                        {
                            "source": "#main/output_cao",
                            "id": "#main/force_tsa/output_cao"
                        },
                        {
                            "source": "#main/output_caq",
                            "id": "#main/force_tsa/output_caq"
                        },
                        {
                            "source": "#main/output_caw",
                            "id": "#main/force_tsa/output_caw"
                        },
                        {
                            "source": "#main/output_cay",
                            "id": "#main/force_tsa/output_cay"
                        },
                        {
                            "source": "#main/output_explode",
                            "id": "#main/force_tsa/output_explode"
                        },
                        {
                            "source": "#main/output_fbd",
                            "id": "#main/force_tsa/output_fbd"
                        },
                        {
                            "source": "#main/output_fbm",
                            "id": "#main/force_tsa/output_fbm"
                        },
                        {
                            "source": "#main/output_fbq",
                            "id": "#main/force_tsa/output_fbq"
                        },
                        {
                            "source": "#main/output_fbw",
                            "id": "#main/force_tsa/output_fbw"
                        },
                        {
                            "source": "#main/output_fby",
                            "id": "#main/force_tsa/output_fby"
                        },
                        {
                            "source": "#main/output_format",
                            "id": "#main/force_tsa/output_format"
                        },
                        {
                            "source": "#main/output_nrt",
                            "id": "#main/force_tsa/output_nrt"
                        },
                        {
                            "source": "#main/output_pct",
                            "id": "#main/force_tsa/output_pct"
                        },
                        {
                            "source": "#main/output_pol",
                            "id": "#main/force_tsa/output_pol"
                        },
                        {
                            "source": "#main/output_stm",
                            "id": "#main/force_tsa/output_stm"
                        },
                        {
                            "source": "#main/output_trd",
                            "id": "#main/force_tsa/output_trd"
                        },
                        {
                            "source": "#main/output_trm",
                            "id": "#main/force_tsa/output_trm"
                        },
                        {
                            "source": "#main/output_tro",
                            "id": "#main/force_tsa/output_tro"
                        },
                        {
                            "source": "#main/output_trq",
                            "id": "#main/force_tsa/output_trq"
                        },
                        {
                            "source": "#main/output_trw",
                            "id": "#main/force_tsa/output_trw"
                        },
                        {
                            "source": "#main/output_try",
                            "id": "#main/force_tsa/output_try"
                        },
                        {
                            "source": "#main/output_tsi",
                            "id": "#main/force_tsa/output_tsi"
                        },
                        {
                            "source": "#main/output_tss",
                            "id": "#main/force_tsa/output_tss"
                        },
                        {
                            "source": "#main/pol",
                            "id": "#main/force_tsa/pol"
                        },
                        {
                            "source": "#main/pol_adaptive",
                            "id": "#main/force_tsa/pol_adaptive"
                        },
                        {
                            "source": "#main/pol_end_threshold",
                            "id": "#main/force_tsa/pol_end_threshold"
                        },
                        {
                            "source": "#main/pol_mid_threshold",
                            "id": "#main/force_tsa/pol_mid_threshold"
                        },
                        {
                            "source": "#main/pol_start_threshold",
                            "id": "#main/force_tsa/pol_start_threshold"
                        },
                        {
                            "source": "#main/product_type_main",
                            "id": "#main/force_tsa/product_type_main"
                        },
                        {
                            "source": "#main/product_type_quality",
                            "id": "#main/force_tsa/product_type_quality"
                        },
                        {
                            "source": "#main/rbf_cutoff",
                            "id": "#main/force_tsa/rbf_cutoff"
                        },
                        {
                            "source": "#main/rbf_sigma",
                            "id": "#main/force_tsa/rbf_sigma"
                        },
                        {
                            "source": "#main/reduce_psf",
                            "id": "#main/force_tsa/reduce_psf"
                        },
                        {
                            "source": "#main/resolution",
                            "id": "#main/force_tsa/resolution"
                        },
                        {
                            "source": "#main/screen_qai",
                            "id": "#main/force_tsa/screen_qai"
                        },
                        {
                            "source": "#main/sensors",
                            "id": "#main/force_tsa/sensors"
                        },
                        {
                            "source": "#main/spectral_adjust",
                            "id": "#main/force_tsa/spectral_adjust"
                        },
                        {
                            "source": "#main/standardize_fold",
                            "id": "#main/force_tsa/standardize_fold"
                        },
                        {
                            "source": "#main/standardize_pol",
                            "id": "#main/force_tsa/standardize_pol"
                        },
                        {
                            "source": "#main/standardize_tsi",
                            "id": "#main/force_tsa/standardize_tsi"
                        },
                        {
                            "source": "#main/standardize_tss",
                            "id": "#main/force_tsa/standardize_tss"
                        },
                        {
                            "source": "#main/stm",
                            "id": "#main/force_tsa/stm"
                        },
                        {
                            "source": "#main/target_sensor",
                            "id": "#main/force_tsa/target_sensor"
                        },
                        {
                            "source": "#main/trend_conf",
                            "id": "#main/force_tsa/trend_conf"
                        },
                        {
                            "source": "#main/trend_tail",
                            "id": "#main/force_tsa/trend_tail"
                        },
                        {
                            "source": "#main/use_l2_improphe",
                            "id": "#main/force_tsa/use_l2_improphe"
                        },
                        {
                            "source": "#main/x_tile_range",
                            "id": "#main/force_tsa/x_tile_range"
                        },
                        {
                            "source": "#main/y_tile_range",
                            "id": "#main/force_tsa/y_tile_range"
                        }
                    ],
                    "out": [
                        "#main/force_tsa/tsa_cube"
                    ],
                    "id": "#main/force_tsa"
                },
                {
                    "run": "#staging.cwl",
                    "in": [
                        {
                            "default": "staging",
                            "id": "#main/staging/output_path_base"
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
                }
            ],
            "id": "#main",
            "outputs": [
                {
                    "type": "Directory",
                    "outputSource": "#main/force_tsa/tsa_cube",
                    "id": "#main/tsa_cube"
                }
            ]
        },
        {
            "class": "CommandLineTool",
            "requirements": [
                {
                    "dockerPull": "quay.io/bcdev/force-eoap:0.5.2-dev1",
                    "class": "DockerRequirement"
                },
                {
                    "networkAccess": true,
                    "class": "NetworkAccess"
                },
                {
                    "ramMin": 16384,
                    "ramMax": 16384,
                    "coresMin": 1,
                    "coresMax": 4,
                    "class": "ResourceRequirement"
                },
                {
                    "types": [
                        {
                            "$import": "#force-enums.yml/sensors_type"
                        },
                        {
                            "$import": "#force-enums.yml/screen_qai_type"
                        },
                        {
                            "$import": "#force-enums.yml/index_type"
                        },
                        {
                            "$import": "#force-enums.yml/standardize_type"
                        },
                        {
                            "$import": "#force-enums.yml/interpolate_type"
                        },
                        {
                            "$import": "#force-enums.yml/stm_type"
                        },
                        {
                            "$import": "#force-enums.yml/fold_type_type"
                        },
                        {
                            "$import": "#force-enums.yml/pol_type"
                        },
                        {
                            "$import": "#force-enums.yml/trend_tail_type"
                        },
                        {
                            "$import": "#force-enums.yml/output_format_type"
                        }
                    ],
                    "class": "SchemaDefRequirement"
                }
            ],
            "baseCommand": "/opt/apex-force-wrapper/bin/force-tsa-wrapper.sh",
            "inputs": [
                {
                    "type": "float",
                    "inputBinding": {
                        "prefix": "--above_noise"
                    },
                    "default": 0,
                    "id": "#force-tsa.cwl/above_noise"
                },
                {
                    "type": "float",
                    "inputBinding": {
                        "prefix": "--below_noise"
                    },
                    "default": 0,
                    "id": "#force-tsa.cwl/below_noise"
                },
                {
                    "type": "boolean",
                    "inputBinding": {
                        "prefix": "--change_penalty"
                    },
                    "default": false,
                    "id": "#force-tsa.cwl/change_penalty"
                },
                {
                    "type": {
                        "type": "array",
                        "items": "int"
                    },
                    "inputBinding": {
                        "prefix": "--chunk_size",
                        "itemSeparator": ","
                    },
                    "default": [
                        7500,
                        7500
                    ],
                    "id": "#force-tsa.cwl/chunk_size"
                },
                {
                    "type": {
                        "type": "array",
                        "items": "string"
                    },
                    "inputBinding": {
                        "prefix": "--date_range",
                        "itemSeparator": ","
                    },
                    "id": "#force-tsa.cwl/date_range"
                },
                {
                    "type": {
                        "type": "array",
                        "items": "int"
                    },
                    "inputBinding": {
                        "prefix": "--doy_range",
                        "itemSeparator": ","
                    },
                    "default": [
                        1,
                        365
                    ],
                    "id": "#force-tsa.cwl/doy_range"
                },
                {
                    "type": "boolean",
                    "inputBinding": {
                        "prefix": "--fail_if_empty"
                    },
                    "default": false,
                    "id": "#force-tsa.cwl/fail_if_empty"
                },
                {
                    "type": {
                        "type": "array",
                        "items": "string"
                    },
                    "inputBinding": {
                        "prefix": "--file_tile",
                        "itemSeparator": ","
                    },
                    "default": null,
                    "id": "#force-tsa.cwl/file_tile"
                },
                {
                    "type": {
                        "type": "array",
                        "items": "#force-enums.yml/fold_type_type"
                    },
                    "inputBinding": {
                        "prefix": "--fold_type",
                        "itemSeparator": ","
                    },
                    "default": [
                        "AVG"
                    ],
                    "id": "#force-tsa.cwl/fold_type"
                },
                {
                    "type": {
                        "type": "array",
                        "items": "string"
                    },
                    "inputBinding": {
                        "prefix": "--harmonic_fit_range",
                        "itemSeparator": ","
                    },
                    "default": [
                        "1970-01-01",
                        "2099-01-01"
                    ],
                    "id": "#force-tsa.cwl/harmonic_fit_range"
                },
                {
                    "type": "int",
                    "inputBinding": {
                        "prefix": "--harmonic_modes"
                    },
                    "default": 3,
                    "id": "#force-tsa.cwl/harmonic_modes"
                },
                {
                    "type": "boolean",
                    "inputBinding": {
                        "prefix": "--harmonic_trend"
                    },
                    "default": false,
                    "id": "#force-tsa.cwl/harmonic_trend"
                },
                {
                    "type": {
                        "type": "array",
                        "items": "#force-enums.yml/index_type"
                    },
                    "inputBinding": {
                        "prefix": "--index",
                        "itemSeparator": ","
                    },
                    "default": [
                        "NDVI",
                        "EVI",
                        "NBR"
                    ],
                    "id": "#force-tsa.cwl/index"
                },
                {
                    "type": "Directory",
                    "inputBinding": {
                        "prefix": "--input_data_dir"
                    },
                    "id": "#force-tsa.cwl/input_data_dir"
                },
                {
                    "type": "int",
                    "inputBinding": {
                        "prefix": "--int_day"
                    },
                    "default": 16,
                    "id": "#force-tsa.cwl/int_day"
                },
                {
                    "type": "#force-enums.yml/interpolate_type",
                    "inputBinding": {
                        "prefix": "--interpolate"
                    },
                    "default": "NONE",
                    "id": "#force-tsa.cwl/interpolate"
                },
                {
                    "type": "int",
                    "inputBinding": {
                        "prefix": "--moving_max"
                    },
                    "default": 16,
                    "id": "#force-tsa.cwl/moving_max"
                },
                {
                    "type": [
                        "null",
                        "string"
                    ],
                    "inputBinding": {
                        "prefix": "--name"
                    },
                    "id": "#force-tsa.cwl/name"
                },
                {
                    "type": "boolean",
                    "inputBinding": {
                        "prefix": "--output_cad"
                    },
                    "default": false,
                    "id": "#force-tsa.cwl/output_cad"
                },
                {
                    "type": "boolean",
                    "inputBinding": {
                        "prefix": "--output_cam"
                    },
                    "default": false,
                    "id": "#force-tsa.cwl/output_cam"
                },
                {
                    "type": "boolean",
                    "inputBinding": {
                        "prefix": "--output_cao"
                    },
                    "default": false,
                    "id": "#force-tsa.cwl/output_cao"
                },
                {
                    "type": "boolean",
                    "inputBinding": {
                        "prefix": "--output_caq"
                    },
                    "default": false,
                    "id": "#force-tsa.cwl/output_caq"
                },
                {
                    "type": "boolean",
                    "inputBinding": {
                        "prefix": "--output_caw"
                    },
                    "default": false,
                    "id": "#force-tsa.cwl/output_caw"
                },
                {
                    "type": "boolean",
                    "inputBinding": {
                        "prefix": "--output_cay"
                    },
                    "default": false,
                    "id": "#force-tsa.cwl/output_cay"
                },
                {
                    "type": "boolean",
                    "inputBinding": {
                        "prefix": "--output_explode"
                    },
                    "default": false,
                    "id": "#force-tsa.cwl/output_explode"
                },
                {
                    "type": "boolean",
                    "inputBinding": {
                        "prefix": "--output_fbd"
                    },
                    "default": false,
                    "id": "#force-tsa.cwl/output_fbd"
                },
                {
                    "type": "boolean",
                    "inputBinding": {
                        "prefix": "--output_fbm"
                    },
                    "default": false,
                    "id": "#force-tsa.cwl/output_fbm"
                },
                {
                    "type": "boolean",
                    "inputBinding": {
                        "prefix": "--output_fbq"
                    },
                    "default": false,
                    "id": "#force-tsa.cwl/output_fbq"
                },
                {
                    "type": "boolean",
                    "inputBinding": {
                        "prefix": "--output_fbw"
                    },
                    "default": false,
                    "id": "#force-tsa.cwl/output_fbw"
                },
                {
                    "type": "boolean",
                    "inputBinding": {
                        "prefix": "--output_fby"
                    },
                    "default": false,
                    "id": "#force-tsa.cwl/output_fby"
                },
                {
                    "type": "#force-enums.yml/output_format_type",
                    "inputBinding": {
                        "prefix": "--output_format"
                    },
                    "default": "GTiff",
                    "id": "#force-tsa.cwl/output_format"
                },
                {
                    "type": "boolean",
                    "inputBinding": {
                        "prefix": "--output_nrt"
                    },
                    "default": false,
                    "id": "#force-tsa.cwl/output_nrt"
                },
                {
                    "type": "boolean",
                    "inputBinding": {
                        "prefix": "--output_pct"
                    },
                    "default": false,
                    "id": "#force-tsa.cwl/output_pct"
                },
                {
                    "type": "boolean",
                    "inputBinding": {
                        "prefix": "--output_pol"
                    },
                    "default": false,
                    "id": "#force-tsa.cwl/output_pol"
                },
                {
                    "type": "boolean",
                    "inputBinding": {
                        "prefix": "--output_stm"
                    },
                    "default": false,
                    "id": "#force-tsa.cwl/output_stm"
                },
                {
                    "type": "boolean",
                    "inputBinding": {
                        "prefix": "--output_trd"
                    },
                    "default": false,
                    "id": "#force-tsa.cwl/output_trd"
                },
                {
                    "type": "boolean",
                    "inputBinding": {
                        "prefix": "--output_trm"
                    },
                    "default": false,
                    "id": "#force-tsa.cwl/output_trm"
                },
                {
                    "type": "boolean",
                    "inputBinding": {
                        "prefix": "--output_tro"
                    },
                    "default": false,
                    "id": "#force-tsa.cwl/output_tro"
                },
                {
                    "type": "boolean",
                    "inputBinding": {
                        "prefix": "--output_trq"
                    },
                    "default": false,
                    "id": "#force-tsa.cwl/output_trq"
                },
                {
                    "type": "boolean",
                    "inputBinding": {
                        "prefix": "--output_trw"
                    },
                    "default": false,
                    "id": "#force-tsa.cwl/output_trw"
                },
                {
                    "type": "boolean",
                    "inputBinding": {
                        "prefix": "--output_try"
                    },
                    "default": false,
                    "id": "#force-tsa.cwl/output_try"
                },
                {
                    "type": "boolean",
                    "inputBinding": {
                        "prefix": "--output_tsi"
                    },
                    "default": false,
                    "id": "#force-tsa.cwl/output_tsi"
                },
                {
                    "type": "boolean",
                    "inputBinding": {
                        "prefix": "--output_tss"
                    },
                    "default": false,
                    "id": "#force-tsa.cwl/output_tss"
                },
                {
                    "type": {
                        "type": "array",
                        "items": "#force-enums.yml/pol_type"
                    },
                    "inputBinding": {
                        "prefix": "--pol",
                        "itemSeparator": ","
                    },
                    "default": [
                        "VSS",
                        "VPS",
                        "VES",
                        "VSA",
                        "RMR",
                        "IGS"
                    ],
                    "id": "#force-tsa.cwl/pol"
                },
                {
                    "type": "boolean",
                    "inputBinding": {
                        "prefix": "--pol_adaptive"
                    },
                    "default": false,
                    "id": "#force-tsa.cwl/pol_adaptive"
                },
                {
                    "type": "float",
                    "inputBinding": {
                        "prefix": "--pol_end_threshold"
                    },
                    "default": 0.8,
                    "id": "#force-tsa.cwl/pol_end_threshold"
                },
                {
                    "type": "float",
                    "inputBinding": {
                        "prefix": "--pol_mid_threshold"
                    },
                    "default": 0.5,
                    "id": "#force-tsa.cwl/pol_mid_threshold"
                },
                {
                    "type": "float",
                    "inputBinding": {
                        "prefix": "--pol_start_threshold"
                    },
                    "default": 0.2,
                    "id": "#force-tsa.cwl/pol_start_threshold"
                },
                {
                    "type": "string",
                    "inputBinding": {
                        "prefix": "--product_type_main"
                    },
                    "default": "BOA",
                    "id": "#force-tsa.cwl/product_type_main"
                },
                {
                    "type": "string",
                    "inputBinding": {
                        "prefix": "--product_type_quality"
                    },
                    "default": "QAI",
                    "id": "#force-tsa.cwl/product_type_quality"
                },
                {
                    "type": "float",
                    "inputBinding": {
                        "prefix": "--rbf_cutoff"
                    },
                    "default": 0.95,
                    "id": "#force-tsa.cwl/rbf_cutoff"
                },
                {
                    "type": {
                        "type": "array",
                        "items": "int"
                    },
                    "inputBinding": {
                        "prefix": "--rbf_sigma",
                        "itemSeparator": ","
                    },
                    "default": [
                        8,
                        16,
                        32
                    ],
                    "id": "#force-tsa.cwl/rbf_sigma"
                },
                {
                    "type": "boolean",
                    "inputBinding": {
                        "prefix": "--reduce_psf"
                    },
                    "default": false,
                    "id": "#force-tsa.cwl/reduce_psf"
                },
                {
                    "type": "int",
                    "inputBinding": {
                        "prefix": "--resolution"
                    },
                    "default": 20,
                    "id": "#force-tsa.cwl/resolution"
                },
                {
                    "type": {
                        "type": "array",
                        "items": "#force-enums.yml/screen_qai_type"
                    },
                    "inputBinding": {
                        "prefix": "--screen_qai",
                        "itemSeparator": ","
                    },
                    "default": [
                        "NODATA",
                        "CLOUD_OPAQUE",
                        "CLOUD_BUFFER",
                        "CLOUD_CIRRUS",
                        "CLOUD_SHADOW",
                        "SNOW",
                        "SUBZERO",
                        "SATURATION"
                    ],
                    "id": "#force-tsa.cwl/screen_qai"
                },
                {
                    "type": {
                        "type": "array",
                        "items": "#force-enums.yml/sensors_type"
                    },
                    "inputBinding": {
                        "prefix": "--sensors",
                        "itemSeparator": ","
                    },
                    "default": [
                        "SEN2A",
                        "SEN2B",
                        "SEN2C"
                    ],
                    "id": "#force-tsa.cwl/sensors"
                },
                {
                    "type": "boolean",
                    "inputBinding": {
                        "prefix": "--spectral_adjust"
                    },
                    "default": false,
                    "id": "#force-tsa.cwl/spectral_adjust"
                },
                {
                    "type": "#force-enums.yml/standardize_type",
                    "inputBinding": {
                        "prefix": "--standardize_fold"
                    },
                    "default": "NONE",
                    "id": "#force-tsa.cwl/standardize_fold"
                },
                {
                    "type": "#force-enums.yml/standardize_type",
                    "inputBinding": {
                        "prefix": "--standardize_pol"
                    },
                    "default": "NONE",
                    "id": "#force-tsa.cwl/standardize_pol"
                },
                {
                    "type": "#force-enums.yml/standardize_type",
                    "inputBinding": {
                        "prefix": "--standardize_tsi"
                    },
                    "default": "NONE",
                    "id": "#force-tsa.cwl/standardize_tsi"
                },
                {
                    "type": "#force-enums.yml/standardize_type",
                    "inputBinding": {
                        "prefix": "--standardize_tss"
                    },
                    "default": "NONE",
                    "id": "#force-tsa.cwl/standardize_tss"
                },
                {
                    "type": {
                        "type": "array",
                        "items": "#force-enums.yml/stm_type"
                    },
                    "inputBinding": {
                        "prefix": "--stm",
                        "itemSeparator": ","
                    },
                    "default": [
                        "NONE"
                    ],
                    "id": "#force-tsa.cwl/stm"
                },
                {
                    "type": "#force-enums.yml/sensors_type",
                    "inputBinding": {
                        "prefix": "--target_sensor"
                    },
                    "default": "SEN2L",
                    "id": "#force-tsa.cwl/target_sensor"
                },
                {
                    "type": "float",
                    "inputBinding": {
                        "prefix": "--trend_conf"
                    },
                    "default": 0.95,
                    "id": "#force-tsa.cwl/trend_conf"
                },
                {
                    "type": "#force-enums.yml/trend_tail_type",
                    "inputBinding": {
                        "prefix": "--trend_tail"
                    },
                    "default": "TWO",
                    "id": "#force-tsa.cwl/trend_tail"
                },
                {
                    "type": "boolean",
                    "inputBinding": {
                        "prefix": "--use_l2_improphe"
                    },
                    "default": false,
                    "id": "#force-tsa.cwl/use_l2_improphe"
                },
                {
                    "type": {
                        "type": "array",
                        "items": "int"
                    },
                    "inputBinding": {
                        "prefix": "--x_tile_range",
                        "itemSeparator": ","
                    },
                    "default": [
                        -999,
                        9999
                    ],
                    "id": "#force-tsa.cwl/x_tile_range"
                },
                {
                    "type": {
                        "type": "array",
                        "items": "int"
                    },
                    "inputBinding": {
                        "prefix": "--y_tile_range",
                        "itemSeparator": ","
                    },
                    "default": [
                        -999,
                        9999
                    ],
                    "id": "#force-tsa.cwl/y_tile_range"
                }
            ],
            "outputs": [
                {
                    "type": "Directory",
                    "outputBinding": {
                        "glob": "force-tsa"
                    },
                    "id": "#force-tsa.cwl/tsa_cube"
                }
            ],
            "id": "#force-tsa.cwl"
        },
        {
            "class": "CommandLineTool",
            "requirements": [
                {
                    "dockerPull": "quay.io/bcdev/force-eoap:0.5.2-dev1",
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
