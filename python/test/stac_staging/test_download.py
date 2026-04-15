import pystac
import pytest

from stac_staging.download import download_by_asset


@pytest.fixture
def stac_item(item_path) -> pystac.Item:
    item_url = str(item_path)
    item = pystac.read_file(item_url)
    assert isinstance(item, pystac.Item)
    return item


@pytest.mark.parametrize("synchronous", [True, False])
def test_download_by_asset(stac_item, tmp_path, synchronous):
    download_by_asset([stac_item], tmp_path, synchronous=synchronous)
    downloaded = set(p.name for p in tmp_path.iterdir())
    assert {"b.txt", "c.txt"} == downloaded
