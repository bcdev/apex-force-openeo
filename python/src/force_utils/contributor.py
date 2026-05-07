import importlib
import json
import re
from abc import ABCMeta, abstractmethod
from collections.abc import Set
from datetime import datetime, timezone
from functools import lru_cache
from pathlib import Path
from typing import Optional, List, Dict, Any

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
    def process_parameter_files(
        cls, l2_parameter_path: Optional[Path], parameter_path: Optional[Path]
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
    @classmethod
    def process_store(
        cls, store: ForceDatacubeStore, catalog: pystac.Catalog, item: pystac.Item
    ) -> None:
        raise NotImplementedError()

    @classmethod
    def process_asset_path(
        cls, absolute: Path, relative: Path, asset: pystac.Asset
    ) -> None:
        raise NotImplementedError()

    @classmethod
    def process_asset_ds(cls, ds: DatasetReader, asset: pystac.Asset) -> None:
        raise NotImplementedError()

    @classmethod
    def process_parameter_files(
        cls, l2_parameter_path: Optional[Path], parameter_path: Optional[Path]
    ) -> None:
        raise NotImplementedError()


class CommonMetadataStacContributor(AbstractStacContributor):
    EXTENSIONS: Set[EXTENSION_NAMES] = set()

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
