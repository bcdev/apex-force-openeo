import importlib
import json
import logging
import re
from abc import ABCMeta, abstractmethod
from collections.abc import Set
from datetime import datetime, timezone
from functools import lru_cache
from pathlib import Path
from typing import List, Dict, Any, Optional

import multihash
import numpy as np
import pystac
import shapely
from pystac.extensions.ext import EXTENSION_NAMES
from rasterio.io import DatasetReader

import force_utils
from force_utils.datacube_store import ForceDatacubeStore

MEDIA_TYPES = {
    ".tif": pystac.MediaType.GEOTIFF,
    ".tiff": pystac.MediaType.GEOTIFF,
    ".jpg": pystac.MediaType.JPEG,
    ".jpeg": pystac.MediaType.JPEG,
}

logger = logging.getLogger(__name__)


class AbstractStacContributor(metaclass=ABCMeta):
    EXTENSIONS = set()

    @classmethod
    def process_store(
        cls, store: ForceDatacubeStore, catalog: pystac.Catalog, item: pystac.Item
    ) -> None: ...

    @classmethod
    def process_asset_path(
        cls, absolute: Path, relative: Path, tile: str, asset: pystac.Asset
    ) -> None: ...

    @classmethod
    @abstractmethod
    def needs_file_ds(cls, path: Path) -> bool: ...

    @classmethod
    def process_asset_ds(
        cls, ds: DatasetReader, tile: str, asset: pystac.Asset
    ) -> None: ...

    @classmethod
    def get_extensions(cls) -> Set[EXTENSION_NAMES]:
        return cls.EXTENSIONS


class Level2StacContributor(AbstractStacContributor):
    # processing and product extensions are not supported by pystac (2026-05-07)
    # {
    #      "processing",
    #      "product"
    # }
    EXTENSIONS: Set[EXTENSION_NAMES] = {"eo"}

    ASSET_FILE_NAME_PATTERN = re.compile(
        # 20160823_LEVEL2  _SEN2A        _BOA        .tif # noqa
        r"(\d{8})_(LEVEL2)_([A-Z0-9]{5})_([A-Z]{3})\.(jpg|tif)"
    )
    DATE_FORMAT = "%Y%m%d"
    SENSOR_ID_MAPPING = {
        "LND04": "Landsat 4 Thematic Mapper",
        "LND05": "Landsat 5 Thematic Mapper",
        "LND07": "Landsat 7 Enhanced Thematic Mapper",
        "LND08": "Landsat 8 Operational Land Imager",
        "LND09": "Landsat 9 Operational Land Imager",
        "SEN2A": "Sentinel-2A MultiSpectral Instrument",
        "SEN2B": "Sentinel-2B MultiSpectral Instrument",
        "SEN2C": "Sentinel-2C MultiSpectral Instrument",
    }
    PRODUCT_TYPE_MAPPING = {
        "BOA": "Bottom-of-Atmosphere Reflectance",
        "TOA": "Top-of-Atmosphere Reflectance",
        "QAI": "Quality Assurance Information",
        "AOD": "Aerosol Optical Depth",
        "DST": "Cloud / Cloud shadow /Snow distance",
        "WVP": "Water vapour",
        "VZN": "View zenith",
        "HOT": "Haze Optimized Transformation",
    }
    ROLES_MAPPING = {
        "tif": ["data"],
        "jpg": ["thumbnail"],
    }

    @classmethod
    def process_store(
        cls, store: ForceDatacubeStore, catalog: pystac.Catalog, item: pystac.Item
    ) -> None:
        # Needed, as long as extensions are not supported by pystac
        item.stac_extensions.append(
            "https://stac-extensions.github.io/product/v1.0.0/schema.json"
        )
        item.stac_extensions.append(
            "https://stac-extensions.github.io/processing/v1.2.0/schema.json"
        )
        item.properties["processing:level"] = "L2"
        # TODO
        # item.properties["processing:version"] =
        # item.properties["processing:facility"] =
        software = item.properties.get("processing:software", {})
        software |= {
            # "FORCE": "TBD" # TODO
            "apex-force-openeo": force_utils.__version__
        }
        item.properties["processing:software"] = software
        item.properties["product:type"] = "FORCE_L2_ARD"
        item.ext.eo.bands = cls.get_bands()

    @classmethod
    def process_asset_path(
        cls, absolute: Path, relative: Path, tile: str, asset: pystac.Asset
    ) -> None:
        """
        See https://force-eo.readthedocs.io/en/latest/components/lower-level/level2/format.html#datacube-def
        for a description of asset name interpretations.

        :param absolute:
        :param relative:
        :param tile:
        :param asset:
        :return:
        """
        m = re.match(cls.ASSET_FILE_NAME_PATTERN, relative.name)
        if m is None:
            l2_output_format_url = "https://force-eo.readthedocs.io/en/latest/components/lower-level/level2/format.html#datacube-def"
            raise ValueError(
                f"Asset {relative.name} ({absolute}) does not match level 2 file naming pattern {cls.ASSET_FILE_NAME_PATTERN.pattern}."
                f" See {l2_output_format_url} for an explanation of the file name pattern for FORCE level 2 outputs."
            )

        acquisition_date = datetime.strptime(m.group(1), cls.DATE_FORMAT).replace(
            tzinfo=timezone.utc
        )
        product_level = m.group(2)
        sensor_id = m.group(3)
        product_type = m.group(4)
        file_extension = m.group(5)

        asset.extra_fields["acquisition_date"] = f"{acquisition_date.isoformat()}Z"
        asset.extra_fields["product_level"] = product_level
        asset.extra_fields["sensor_id_key"] = sensor_id
        if (sensor_id_long := cls.SENSOR_ID_MAPPING.get(sensor_id)) is not None:
            asset.extra_fields["sensor_id"] = sensor_id_long
        asset.extra_fields["product_type_key"] = product_type
        if (
            product_type_long := cls.PRODUCT_TYPE_MAPPING.get(product_type)
        ) is not None:
            asset.extra_fields["product_type"] = product_type_long
        # TODO more sophisticated role handling. We could use the classification extension for QAI for example
        # https://github.com/stac-extensions/classification/blob/main/README.md
        asset.roles = cls.ROLES_MAPPING.get(file_extension, [])
        assert asset.roles
        if "data" in asset.roles:
            asset.ext.eo.bands = cls.get_bands()

    @classmethod
    def needs_file_ds(cls, path: Path) -> bool:
        return False

    @classmethod
    @lru_cache(maxsize=1)
    def _get_l2_bands_metadata(cls) -> List[Dict[str, Any]]:
        band_metadata_resource = importlib.resources.files("force_utils.data").joinpath(
            "sentinel-2-band-metadata.json"
        )
        with band_metadata_resource.open("r") as fp:
            band_metadata = json.load(fp)

        return band_metadata

    @classmethod
    def get_bands(cls) -> List[Dict[str, Any]]:
        bands = [
            pystac.extensions.eo.Band.create(
                {k.removeprefix("eo:"): v for k, v in b.items()}
            )
            for b in cls._get_l2_bands_metadata()
        ]
        return bands


class TsaStacContributor(AbstractStacContributor):
    EXTENSIONS = set()

    PHENOMETRICS_MAPPING = {
        "LSP": "Phenometrics",
        "TRP": "Trend Analysis on Phenometrics",
        "CAP": "Extended CAT Analysis on Phenometrics",
    }
    POLARMETRICS_MAPPING = {
        "POL": "Polarmetrics",
        "TRO": "Trend Analysis on Polarmetrics",
        "CAO": "Extended CAT Analysis on Polarmetrics",
    }

    SENSOR_ID_MAPPING = {
        "LNDLG": "Landsat legacy bands",
        "SEN2L": "Sentinel-2 land bands",
        "SEN2H": "Sentinel-2 high-res bands",
        "R-G-B": "Visible bands",
        "VVHP": "VV/VH Dual Polarized",
    }
    INDEX_NAME_MAPPING = {
        "BLU": "Blue band",
        "GRN": "Green band",
        "RED": "Red band",
        "NIR": "Near Infrared band",
        "SW1": "Shortwave Infrared band 1",
        "SW2": "Shortwave Infrared band 2",
        "RE1": "Red Edge band 1",
        "RE2": "Red Edge band 2",
        "RE3": "Red Edge band 3",
        "BNR": "Broad Near Infrared band",
        "NDV": "Normalized Difference Vegetation Index",
        "EVI": "Enhanced Vegetation Index",
        "NBR": "Normalized Burn Ratio",
        "ARV": "Atmospherically Resistant Vegetation Index",
        "SAV": "Soil Adjusted Vegetation Index",
        "SRV": "Soil and Atmospherically Resistant Vegetation Index",
        "TCB": "Tasseled Cap Brightness",
        "TCG": "Tasseled Cap Greenness",
        "TCW": "Tasseled Cap Wetness",
        "TCD": "Tasseled Cap Disturbance Index (without rescaling)",
        "NDB": "Normalized Difference Building Index",
        "NDW": "Normalized Difference Water Index",
        "MNW": "modified Normalized Difference Water Index",
        "NDS": "Normalized Difference Snow Index",
        "SMA": "Spectral Mixture Analysis abundance",
        "BVV": "VV Polarized band",
        "BVH": "VH Polarized band",
        "ND1": "Normalized Difference Red Edge Index 1",
        "ND2": "Normalized Difference Red Edge Index 2",
        "CRE": "Chlorophyll Index Red Edge",
        "NR1": "Normalized Difference Vegetation Index red edge 1",
        "NR2": "Normalized Difference Vegetation Index red edge 2",
        "NR3": "Normalized Difference Vegetation Index red edge 3",
        "N1N": "Normalized Difference Vegetation Index red edge 1 narrow",
        "N2N": "Normalized Difference Vegetation Index red edge 2 narrow",
        "N3N": "Normalized Difference Vegetation Index red edge 3 narrow",
        "MRE": "Modified Simple Ratio red edge",
        "MRN": "Modified Simple Ratio red edge narrow",
        "CCI": "Chlorophyll Carotenoid Index",
    }
    PRODUCT_TYPE_MAPPING = {
        "TSS": "Time Series Stack",
        "TSI": "Time Series Interpolation",
        "RMS": "RMSE Time Series of SMA",
        "STM": "Spectral Temporal Metrics",
        "FB": "Time Series",
        "TR": "Trend Analysis on Folds",
        "CA": "Extended CAT Analysis on Folds",
    }
    PHENOLOGY_MAPPING = {
        "DEM": "Date of Early Minimum",
        "DSS": "Date of Start of Season",
        "DPS": "Date of Peak of Season",
        "DMS": "Date of Mid of Season",
        "DES": "Date of End of Season",
        "DLM": "Date of Late Minimum",
        "DEV": "Date of Early Average Vector",
        "DAV": "Date of Average Vector",
        "DLV": "Date of Late Average Vector",
        "DPY": "Date of Start of Phenological Year",
        "DPV": "delta Date of adaptive Start of Phenological Year",
        "LTS": "Length of Total Season",
        "LGS": "Length of Green Season",
        "LGV": "Length of between early/late vectors",
        "VEM": "Value of Early Minimum",
        "VSS": "Value of Start of Season",
        "VPS": "Value of Peak of Season",
        "VMS": "Value of Mid of Season",
        "VES": "Value of End of Season",
        "VLM": "Value of Late Minimum",
        "VEV": "Value of Early Average Vector",
        "VAV": "Value of Average Vector",
        "VLV": "Value of Late Average Vector",
        "VBL": "Value of Base Level",
        "VSA": "Value of Seasonal Amplitude",
        "VGA": "Value of Green Amplitude",
        "VPA": "Value of Peak Amplitude",
        "VGM": "Value of Green Mean",
        "VGV": "Value of Green Variability",
        "IST": "Integral of Total Season",
        "IBL": "Integral of Base Level",
        "IBT": "Integral of Base+Total",
        "IGS": "Integral of Green Season",
        "IRR": "Integral of Rising Rate",
        "IFR": "Integral of Falling Rate",
        "RAR": "Rate of Average Rising",
        "RAF": "Rate of Average Falling",
        "RMR": "Rate of Maximum Rising",
        "RMF": "Rate of Maximum Falling",
    }
    FOLDING_TAG_MAPPING = {
        "Y": "Fold by Year",
        "Q": "Fold by Quarter",
        "M": "Fold by Month",
        "W": "Fold by Week",
        "D": "Fold by Day",
    }

    ASSET_FILE_NAME_PATTERN = re.compile(
        # 1984-2020_182-274_HL_TSA_LNDLG_TCG_STM.tif
        # TODO ask FORCE to update documentation (8 digit dates, not just years as claimed by docs)
        # TODO ask FORCE to update documentation (FORCE may generate 4 letter index short names (e.g., NDVI) not 3 letter
        #  as in the docs)
        r"(\d{8}-\d{8})_(\d{3}-\d{3})_HL_TSA_([A-Z0-9-]{5})_([A-Z]{3,4})_([A-Z]+)\.(tif|dat|hdr)"
    )
    PRODUCT_TYPE_FOLDING_PATTERN = re.compile(r"(FB|TR|CA)([YQMWD])")
    PRODUCT_TYPE_PHENOMETRICS_POLARMETRICS_PATTERN = re.compile(
        f"({'|'.join(PHENOLOGY_MAPPING.keys())})-(LSP|TRP|CAP|POL|TRO|CAL)"
    )

    @classmethod
    def process_store(
        cls, store: ForceDatacubeStore, catalog: pystac.Catalog, item: pystac.Item
    ) -> None:
        # Needed, as long as extensions are not supported by pystac
        item.stac_extensions.append(
            "https://stac-extensions.github.io/product/v1.0.0/schema.json"
        )
        item.stac_extensions.append(
            "https://stac-extensions.github.io/processing/v1.2.0/schema.json"
        )
        item.properties["processing:level"] = "L3"
        software = item.properties.get("processing:software", {})
        software |= {
            # "FORCE": "TBD" # TODO
            "apex-force-openeo": force_utils.__version__
        }
        item.properties["processing:software"] = software
        item.properties["product:type"] = "FORCE_TSA"

    @classmethod
    def process_asset_path(
        cls, absolute: Path, relative: Path, tile: str, asset: pystac.Asset
    ) -> None:
        m = re.match(cls.ASSET_FILE_NAME_PATTERN, relative.name)
        if m is None:
            tsa_output_format_url = "https://force-eo.readthedocs.io/en/latest/components/higher-level/tsa/format.html"
            raise ValueError(
                f"Asset {relative.name} ({absolute}) does not match TSA file naming pattern {cls.ASSET_FILE_NAME_PATTERN.pattern}."
                f" See {tsa_output_format_url} for an explanation of the file name pattern for FORCE TSA outputs."
            )
        temporal_range = m.group(1)
        temporal_range_doy = m.group(2)
        product_level = "HL"  # higher level
        submodule = "TSA"  # Time Series Analysis
        sensor_id = m.group(3)
        index_short_name = m.group(4)
        product_type = m.group(5)
        file_extension = m.group(6)

        asset.extra_fields["temporal_range"] = temporal_range
        asset.extra_fields["temporal_range_doy"] = temporal_range_doy
        asset.extra_fields["product_level"] = product_level
        asset.extra_fields["submodule"] = submodule
        asset.extra_fields["sensor_id_key"] = sensor_id
        if (sensor_id_long := cls.SENSOR_ID_MAPPING.get(sensor_id)) is not None:
            asset.extra_fields["sensor_id"] = sensor_id_long
        asset.extra_fields["index_short_name_key"] = index_short_name
        if (index_name := cls.INDEX_NAME_MAPPING.get(index_short_name)) is not None:
            asset.extra_fields["index_short_name"] = index_name

        asset.extra_fields["product_type_key"] = product_type
        product_type_long = cls._get_product_type_long_name(product_type)
        if product_type_long is not None:
            asset.extra_fields["product_type"] = product_type_long

        asset.roles = ["metadata"] if file_extension == "hdr" else ["data"]

    @classmethod
    def needs_file_ds(cls, path: Path) -> bool:
        return False

    @classmethod
    def process_asset_ds(
        cls, ds: DatasetReader, tile: str, asset: pystac.Asset
    ) -> None:
        raise NotImplementedError()

    @classmethod
    def _get_product_type_long_name(cls, product_type_key) -> Optional[str]:
        # Case 1: Three-letter simple product type, e.g TSS
        simple_product_type_long = cls.PRODUCT_TYPE_MAPPING.get(product_type_key)
        if simple_product_type_long is not None:
            return simple_product_type_long

        # Case 2: Three-letter product type with time folding tag (e.g. FBY/FBM)
        m = re.match(cls.PRODUCT_TYPE_FOLDING_PATTERN, product_type_key)
        if m is not None:
            analysis_type = cls.PRODUCT_TYPE_MAPPING.get(m.group(1))
            folding_tag = cls.FOLDING_TAG_MAPPING.get(m.group(2))
            if analysis_type is None or folding_tag is None:
                logger.warning(
                    f"Could not interpret '{product_type_key}' as folding product type"
                )
                return None
            product_type_long = f"{analysis_type} ({folding_tag})"
            return product_type_long

        # Case 3: Two-component product type (phenometric/polarmetric)
        m = re.match(
            cls.PRODUCT_TYPE_PHENOMETRICS_POLARMETRICS_PATTERN, product_type_key
        )
        if m is not None:
            phenology_name_tag = cls.PHENOLOGY_MAPPING.get(m.group(1))
            analysis_type = cls.PHENOMETRICS_MAPPING.get(
                m.group(2)
            ) or cls.POLARMETRICS_MAPPING.get(m.group(2))
            if phenology_name_tag is None or analysis_type is None:
                logger.warning(
                    f"Could not interpret '{product_type_key} as phenolometric/polarmetric product type"
                )
                return None
            product_type_long = f"{analysis_type} ({phenology_name_tag})"
            return product_type_long

        logger.warning(
            f"Could not interpret '{product_type_key}' as any known product type"
        )
        return None


class CommonMetadataStacContributor(AbstractStacContributor):
    EXTENSIONS: Set[EXTENSION_NAMES] = set()

    PARAMETER_BLACKLIST: List[str] = [
        # Level 2
        "FILE_QUEUE",
        "DIR_LEVEL2",
        "DIR_LOG",
        "DIR_PROVENANCE",
        "DIR_TEMP",
    ]

    @classmethod
    def process_store(
        cls, store: ForceDatacubeStore, catalog: pystac.Catalog, item: pystac.Item
    ) -> None:
        bbox = store.compute_bounding_box()
        item.geometry = json.loads(shapely.to_geojson(bbox))
        item.bbox = list(bbox.bounds)

        assert item.datetime
        now_iso = f"{item.datetime.isoformat()}Z"
        item.properties["created"] = now_iso
        item.properties["updated"] = now_iso
        parameter_files = store.get_parameter_files()
        if parameter_files:
            for parameter_path in parameter_files:
                cls.process_parameter_file(parameter_path, store, item=item)

    @classmethod
    def process_parameter_file(
        cls,
        parameter_path: Path,
        store: ForceDatacubeStore,
        item: pystac.Item,
    ):
        with open(parameter_path) as fp:
            # ++PARAM_LEVEL2_START++
            parameter_type = (
                fp.readline().strip().removeprefix("++PARAM_").removesuffix("_START++")
            )
            parameter_lines = filter(
                lambda l: not (
                    l.strip().startswith("#") or l.strip().startswith("+") or len(l) < 2
                ),
                fp.readlines(),
            )

        key = f"FORCE:{parameter_type}_parameters"
        item.properties[key] = {}
        for parameter_line in parameter_lines:
            param_name, param_value = map(
                lambda p: p.strip(), parameter_line.split("=")
            )
            if not param_name in cls.PARAMETER_BLACKLIST:
                item.properties[key][param_name] = param_value

        # TODO if parameter file is relative to datacube root, add as asset
        try:
            parameter_path_relative = store.get_relative_path(parameter_path)
            parameter_asset = pystac.Asset(
                href=str(parameter_path_relative),
            )
            item.add_asset(
                key=key,
                asset=parameter_asset,
            )
        except ValueError:
            logger.warning(
                f"Could not add parameter file '{parameter_path.name}' as asset, "
                f"it must be relative to the data cube root '{store._data_cube_root}', "
                f"but is located at '{parameter_path.resolve()}'"
            )

    @classmethod
    def process_asset_path(
        cls, absolute: Path, relative: Path, tile: str, asset: pystac.Asset
    ) -> None:
        asset_title = f"{tile}_{relative.stem}".replace("_", " ")
        asset.title = asset_title
        asset.media_type = MEDIA_TYPES.get(relative.suffix)

    @classmethod
    def needs_file_ds(cls, path: Path) -> bool:
        return False


class FileExtensionMetadataStacContributor(AbstractStacContributor):
    EXTENSIONS: Set[EXTENSION_NAMES] = {"file"}

    @classmethod
    def process_asset_path(
        cls, absolute: Path, relative: Path, tile: str, asset: pystac.Asset
    ) -> None:
        asset.ext.file.size = absolute.stat(follow_symlinks=True).st_size
        asset.ext.file.local_path = str(relative)

        mh = multihash.digest(absolute.read_bytes(), multihash.Func.sha2_256)
        mh_digest = multihash.encode(mh.digest, multihash.Func.sha2_256)
        asset.ext.file.checksum = multihash.to_hex_string(mh_digest)

    @classmethod
    def needs_file_ds(cls, path: Path) -> bool:
        return False


class ProjExtensionMetadataStacContributor(AbstractStacContributor):
    EXTENSIONS: Set[EXTENSION_NAMES] = {"proj"}

    # TODO more sophisticated selection?
    @classmethod
    def needs_file_ds(cls, path: Path) -> bool:
        return path.suffix in [".tif", ".tiff"]

    @classmethod
    def process_asset_ds(
        cls, ds: DatasetReader, tile: str, asset: pystac.Asset
    ) -> None:
        crs = ds.crs
        bbox = shapely.geometry.box(
            minx=ds.bounds.left,
            maxx=ds.bounds.right,
            miny=ds.bounds.bottom,
            maxy=ds.bounds.top,
        )
        centroid_lon, centroid_lat = ds.lnglat()

        # Projection extension

        asset.ext.proj.code = ":".join(crs.to_authority())
        asset.ext.proj.wkt2 = crs.wkt
        asset.ext.proj.bbox = bbox.bounds
        asset.ext.proj.geometry = json.loads(shapely.to_geojson(bbox))
        asset.ext.proj.transform = ds.transform
        asset.ext.proj.shape = ds.shape
        asset.ext.proj.centroid = {
            "lat": centroid_lat,
            "lon": centroid_lon,
        }


class RasterExtensionMetadataStacContributor(AbstractStacContributor):
    EXTENSIONS: Set[EXTENSION_NAMES] = {"raster"}

    @classmethod
    def needs_file_ds(cls, path: Path) -> bool:
        return path.suffix in [".tif", ".tiff"]

    @classmethod
    def process_asset_ds(
        cls, ds: DatasetReader, tile: str, asset: pystac.Asset
    ) -> None:
        scale = ds.scales[0]
        assert all(
            [s == scale for s in ds.scales]
        ), f"Multiple scales found for asset {asset}"
        asset.ext.raster.scale = scale
        offset = ds.offsets[0]
        assert all(
            [o == offset for o in ds.offsets]
        ), f"Multiple offsets found for asset {asset}"
        asset.ext.raster.offset = offset
        asset.ext.raster.spatial_resolution = np.mean(ds.res)
        asset.ext.raster.sampling = "area"
