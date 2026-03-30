from pathlib import Path

import pystac
import pytest

from stac_staging.download import download_by_asset

ASSETS_DIR = Path(__file__).parent / "data"

ITEM_URL = ASSETS_DIR / "stac" / "test_item" / "test_item.json"


@pytest.fixture
def stac_item() -> pystac.Item:
    item = pystac.read_file(ITEM_URL)
    assert isinstance(item, pystac.Item)
    return item


@pytest.mark.parametrize("synchronous", [True, False])
def test_download_by_asset(stac_item, tmp_path, synchronous):
    download_by_asset([stac_item], tmp_path, synchronous=synchronous)
    downloaded = set(p.name for p in tmp_path.iterdir())
    assert {"b.txt", "c.txt"} == downloaded
