from typing import List

import pystac

SUPPORTED_STAC_OBJECTS: List[str] = ["Item", "ItemCollection", "Catalog", "Collection"]


def convert_stac_object_to_item_collection(
    stac_obj: pystac.STACObject,
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
