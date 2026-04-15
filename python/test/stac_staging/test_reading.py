import json
from typing import Dict

import pystac
import pytest

from stac_staging.util import (
    convert_stac_object_to_item_collection,
    read_stac_from_dict,
)


@pytest.fixture
def catalog_json(catalog_path):
    catalog = pystac.Catalog.from_file(catalog_path)
    catalog_dict = catalog.to_dict()
    return catalog_dict


@pytest.fixture
def item_json(item_path):
    with open(item_path) as f:
        content = json.load(f)
    return content


@pytest.fixture
def item_collection_json(item_collection_path):
    with open(item_collection_path) as f:
        content = json.load(f)
    return content


@pytest.mark.parametrize(
    "stac_json_fixture",
    [
        "catalog_json",
        "item_json",
        "item_collection_json",
    ],
)
def test_read_json(stac_json_fixture: Dict, request):
    stac_json = request.getfixturevalue(stac_json_fixture)
    stac_obj = read_stac_from_dict(stac_json)
    items = convert_stac_object_to_item_collection(stac_obj)

    assert stac_obj is not None
    assert len(items) == 1
