from pathlib import Path

import pytest


@pytest.fixture
def assets_dir() -> Path:
    return Path(__file__).parent / "data"


@pytest.fixture
def item_path(assets_dir) -> Path:
    return assets_dir / "stac" / "test_item" / "test_item.json"


@pytest.fixture
def catalog_path(assets_dir) -> Path:
    return assets_dir / "stac" / "catalog.json"


@pytest.fixture
def item_collection_path(assets_dir) -> Path:
    return assets_dir / "stac" / "test_item_collection.json"
