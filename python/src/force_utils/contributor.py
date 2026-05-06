from abc import ABCMeta, abstractmethod
from pathlib import Path

import pystac
from rasterio.io import DatasetReader

from force_utils.datacube_store import ForceDatacubeStore


class AbstractStacContributor(metaclass=ABCMeta):
    @staticmethod
    @abstractmethod
    def process_store(
        store: ForceDatacubeStore, catalog: pystac.Catalog, item: pystac.Item
    ) -> None: ...

    @staticmethod
    @abstractmethod
    def process_asset_filename(asset_filename: str, asset: pystac.Asset) -> None: ...

    @staticmethod
    @abstractmethod
    def process_asset_ds(ds: DatasetReader, asset: pystac.Asset) -> None: ...

    @staticmethod
    @abstractmethod
    def process_parameter_files(
        l2_parameter_path: Path, parameter_path: Path
    ) -> None: ...


class Level2StacContributor(AbstractStacContributor):
    @staticmethod
    def process_store(
        store: ForceDatacubeStore, catalog: pystac.Catalog, item: pystac.Item
    ) -> None:
        raise NotImplementedError()

    @staticmethod
    def process_asset_filename(asset_filename: str, asset: pystac.Asset) -> None:
        raise NotImplementedError()

    @staticmethod
    def process_asset_ds(ds: DatasetReader, asset: pystac.Asset) -> None:
        raise NotImplementedError()

    @staticmethod
    def process_parameter_files(l2_parameter_path: Path, parameter_path: Path) -> None:
        raise NotImplementedError()


class TsaStacContributor(AbstractStacContributor):
    @staticmethod
    def process_store(
        store: ForceDatacubeStore, catalog: pystac.Catalog, item: pystac.Item
    ) -> None:
        raise NotImplementedError()

    @staticmethod
    def process_asset_filename(asset_filename: str, asset: pystac.Asset) -> None:
        raise NotImplementedError()

    @staticmethod
    def process_asset_ds(ds: DatasetReader, asset: pystac.Asset) -> None:
        raise NotImplementedError()

    @staticmethod
    def process_parameter_files(l2_parameter_path: Path, parameter_path: Path) -> None:
        raise NotImplementedError()


class CommonMetadataStacContributor(AbstractStacContributor):
    @staticmethod
    def process_store(
        store: ForceDatacubeStore, catalog: pystac.Catalog, item: pystac.Item
    ) -> None:
        raise NotImplementedError()

    @staticmethod
    def process_asset_filename(asset_filename: str, asset: pystac.Asset) -> None:
        raise NotImplementedError()

    @staticmethod
    def process_asset_ds(ds: DatasetReader, asset: pystac.Asset) -> None:
        raise NotImplementedError()

    @staticmethod
    def process_parameter_files(l2_parameter_path: Path, parameter_path: Path) -> None:
        raise NotImplementedError()
