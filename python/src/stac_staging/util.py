import json
from typing import List, Union

import pystac

SUPPORTED_STAC_OBJECTS: List[str] = ["Item", "ItemCollection", "Catalog", "Collection"]


def convert_stac_object_to_item_collection(
    stac_obj: Union[pystac.STACObject, pystac.ItemCollection],
) -> pystac.ItemCollection:
    item_collection = None
    match type(stac_obj):
        case pystac.Item:
            assert isinstance(stac_obj, pystac.Item)
            item_collection = pystac.ItemCollection([stac_obj])
        case pystac.ItemCollection:
            item_collection = stac_obj
        case pystac.Catalog:
            assert isinstance(stac_obj, pystac.Catalog)
            item_collection = pystac.ItemCollection(stac_obj.get_items(recursive=True))
        case pystac.Collection:
            assert isinstance(stac_obj, pystac.Collection)
            item_collection = pystac.ItemCollection(stac_obj.get_items(recursive=True))
        case _:
            raise ValueError(
                f"STAC object '{stac_obj}' is not one of the supported types: {SUPPORTED_STAC_OBJECTS}"
            )

    return item_collection


def try_read_stac_from_string(
    string: str,
) -> Union[pystac.ItemCollection, pystac.STACObject]:
    """
    Tries to interpret string either as an URL or as a json representation
    of a STACObject or ItemCollection.
    Raises RuntimeError if no reader succeeds.

    :param string: url to a STAC document / ItemCollection or json representation of the same
    :return: parsed STACObject or ItemCollection
    """
    stac_obj = None
    for reader in [
        pystac.read_file,
        pystac.ItemCollection.from_file,
        lambda s: pystac.read_dict(json.loads(s)),
        lambda s: pystac.ItemCollection.from_dict(json.loads(s)),
    ]:
        try:
            stac_obj = reader(string)
        except (pystac.STACTypeError, FileNotFoundError, TypeError) as _e:
            pass

    if not stac_obj:
        raise RuntimeError(
            f"Could not interpret '{string}' as STAC object or ItemCollection"
        )
    return stac_obj
