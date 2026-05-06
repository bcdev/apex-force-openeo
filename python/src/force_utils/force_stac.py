import json
from datetime import datetime, timezone
from pathlib import Path
from typing import Optional, Iterable

import pystac
import rasterio
import shapely

from force_utils.contributor import (
    AbstractStacContributor,
    CommonMetadataStacContributor,
)
from force_utils.datacube_store import ForceDatacubeStore

MEDIA_TYPES = {
    "tif": pystac.MediaType.GEOTIFF,
    "tiff": pystac.MediaType.GEOTIFF,
}


def get_media_type(path: Path) -> Optional[str]:
    return MEDIA_TYPES.get(path.suffix)


def get_asset_key(tile_id: str, asset_path: Path):
    return f"{tile_id}.{asset_path.stem}"


def get_asset_title(tile_id: str, asset_path: Path):
    return f"{tile_id}_{asset_path.stem}".replace("_", " ")


class ForceStacBuilder:
    CATALOG_ID = "catalog"
    DEFAULT_DESCRIPTION = "FORCE data cube"
    DEFAULT_LAYOUT_STRATEGY = pystac.layout.CustomLayoutStrategy(
        item_func=lambda item, parent: Path(parent) / f"{item.id}.json"
    )

    def __init__(
        self,
        store: ForceDatacubeStore,
        contributors: Iterable[AbstractStacContributor],
        layout_strategy: Optional[pystac.layout.HrefLayoutStrategy] = None,
        l2_parameter_path: Optional[Path] = None,
        parameter_path: Optional[Path] = None,
    ):
        self.store = store
        self.contributors = [self._get_default_contributor(), *contributors]
        self.layout_strategy = layout_strategy or self.DEFAULT_LAYOUT_STRATEGY
        self.l2_parameter_path = l2_parameter_path
        self.parameter_path = parameter_path

    def generate_stac(
        self, item_id: str, description: str = DEFAULT_DESCRIPTION
    ) -> pystac.Catalog:
        catalog = pystac.Catalog(
            self.CATALOG_ID, description, strategy=self.layout_strategy
        )

        bbox = self.store.compute_bounding_box()
        now = datetime.now(tz=timezone.utc)
        now_iso = f"{now.isoformat()}Z"

        item = pystac.Item(
            item_id,
            geometry=json.loads(shapely.to_geojson(bbox)),
            bbox=list(bbox.bounds),
            datetime=now,
            properties={
                "created": now_iso,
                "updated": now_iso,
            },
        )

        for contributor in self.contributors:
            contributor.process_store(self.store, catalog=catalog, item=item)

        for asset_path in self.store.iter_asset_paths():
            asset_path_relative = self.store.get_relative_path(asset_path)

            asset = pystac.Asset(
                href=str(asset_path_relative),
            )

            for contributor in self.contributors:
                contributor.process_asset_filename(
                    asset_path_relative.name, asset=asset
                )

            with rasterio.open(asset_path) as ds:
                for contributor in self.contributors:
                    contributor.process_asset_ds(ds, asset=asset)

        for contributor in self.contributors:
            contributor.process_parameter_files(
                self.l2_parameter_path, self.parameter_path
            )

        return catalog

    @staticmethod
    def _get_default_contributor():
        return CommonMetadataStacContributor()
