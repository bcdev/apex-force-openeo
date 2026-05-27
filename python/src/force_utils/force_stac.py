import logging
from collections.abc import Set
from datetime import datetime, timezone
from pathlib import Path
from typing import Optional, Iterable, List

import pystac
import rasterio
from pystac.extensions.ext import EXTENSION_NAMES

from force_utils.contributor import (
    AbstractStacContributor,
    CommonMetadataStacContributor,
)
from force_utils.datacube_store import ForceDatacubeStore

logger = logging.getLogger(__name__)


class ForceStacBuilder:
    CATALOG_ID = "catalog"
    DEFAULT_DESCRIPTION = "FORCE data cube"
    DEFAULT_LAYOUT_STRATEGY = pystac.layout.CustomLayoutStrategy(
        item_func=lambda item, parent: Path(parent) / f"{item.id}.json"
    )

    store: ForceDatacubeStore
    contributors: List[AbstractStacContributor]
    layout_strategy: Optional[pystac.layout.HrefLayoutStrategy]
    l2_parameter_path: Optional[Path]
    parameter_path: Optional[Path]

    def __init__(
        self,
        store: ForceDatacubeStore,
        contributors: Iterable[AbstractStacContributor],
        layout_strategy: Optional[pystac.layout.HrefLayoutStrategy] = None,
    ):
        self.store = store
        self.contributors = [self._get_default_contributor(), *contributors]
        self.layout_strategy = layout_strategy or self.DEFAULT_LAYOUT_STRATEGY

    def generate_stac(
        self,
        item_id: str,
        description: str = DEFAULT_DESCRIPTION,
    ) -> pystac.Catalog:
        catalog = pystac.Catalog(
            self.CATALOG_ID, description, strategy=self.layout_strategy
        )
        now = datetime.now(tz=timezone.utc)
        item = pystac.Item(
            item_id,
            geometry=None,
            bbox=None,
            datetime=now,
            properties={},
        )
        catalog.add_item(item, strategy=self.layout_strategy)

        extensions: Set[EXTENSION_NAMES] = set().union(
            *(contributor.get_extensions() for contributor in self.contributors)
        )
        for extension in extensions:
            item.ext.add(extension)

        for contributor in self.contributors:
            contributor.process_store(self.store, catalog=catalog, item=item)

        for tile in self.store.iter_tiles():
            for asset_path in self.store.iter_asset_paths(tile):
                asset_path_relative = self.store.get_relative_path(asset_path)

                asset_key = self._get_asset_key(tile, asset_path_relative)
                asset = pystac.Asset(
                    href=str(asset_path),
                )
                item.add_asset(asset_key, asset)

                for contributor in self.contributors:
                    contributor.process_asset_path(
                        asset_path,
                        relative=asset_path_relative,
                        asset=asset,
                        tile=tile,
                    )

                need_file_ds = [
                    contributor
                    for contributor in self.contributors
                    if contributor.needs_file_ds(asset_path)
                ]

                if need_file_ds:
                    with rasterio.open(asset_path) as ds:
                        for contributor in need_file_ds:
                            contributor.process_asset_ds(ds, asset=asset, tile=tile)

        return catalog

    @staticmethod
    def _get_default_contributor() -> AbstractStacContributor:
        return CommonMetadataStacContributor()

    @staticmethod
    def _get_asset_key(tile, asset_path) -> str:
        return f"{tile}.{asset_path.stem}"
