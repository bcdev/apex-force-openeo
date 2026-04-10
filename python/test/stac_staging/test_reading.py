import pytest

from stac_staging.util import (
    try_read_stac_from_string,
    convert_stac_object_to_item_collection,
)


@pytest.fixture
def catalog_json(catalog_path):
    with open(catalog_path) as f:
        content = f.read()
    return content


@pytest.fixture
def item_json(item_path):
    with open(item_path) as f:
        content = f.read()
    return content


@pytest.fixture
def item_collection_json(item_collection_path):
    with open(item_collection_path) as f:
        content = f.read()
    return content


@pytest.mark.parametrize(
    "stac_json_fixture",
    [
        "catalog_json",
        "item_json",
        "item_collection_json",
    ],
)
def test_read_json(stac_json_fixture: str, request):
    stac_json = request.getfixturevalue(stac_json_fixture)
    stac_obj = try_read_stac_from_string(stac_json)
    items = convert_stac_object_to_item_collection(stac_obj)

    assert stac_obj is not None
    assert len(items) == 1


@pytest.mark.parametrize(
    "stac_json_path",
    [
        "catalog_path",
        "item_path",
        "item_collection_path",
    ],
)
def test_read_catalog_url(stac_json_path: str, request):
    stac_path = request.getfixturevalue(stac_json_path)
    stac_obj = try_read_stac_from_string(stac_path)
    items = convert_stac_object_to_item_collection(stac_obj)

    assert stac_obj is not None
    assert len(items) == 1
