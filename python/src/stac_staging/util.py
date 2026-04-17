import shutil
from pathlib import Path
from typing import List, Union, Dict, Optional

import pystac
from pystac import ItemCollection

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


def read_stac_from_dict(
    d: Dict,
    self_url: Optional[str],
) -> Union[pystac.ItemCollection, pystac.STACObject]:
    """
    Interpret dictionary either as an ItemCollection or a STAC object (Catalog, Collection, Item)

    :param d: Dictionary representation a STAC document / ItemCollection
    :param self_url: URL to set as "self" href of the STAC object. Ignored if d is an ItemCollection or base_url is none
    :return: parsed STACObject or ItemCollection
    """
    if ItemCollection.is_item_collection(d):
        stac_obj_or_item_collection = ItemCollection.from_dict(d)
    else:
        stac_obj_or_item_collection = pystac.read_dict(d)
        if self_url is not None:
            stac_obj_or_item_collection.set_self_href(self_url)
    return stac_obj_or_item_collection


def unwrap_single_dir_level(base: Union[Path, str]):
    """
    Move contents of directories inside ``base`` one level up, deleting the containing directories.
    Files in ``base`` are unaffected.
    :param base: Base directory which will contain the contents of all its subdirectories directly after this operation.
    """
    base: Path = Path(base)
    for subpath in base.iterdir():
        if not subpath.is_dir():
            # TODO remove (just for testing)
            raise ValueError(f"{subpath} is not a directory")
            # continue
        for item in subpath.iterdir():
            shutil.move(item, base / item.name)

        subpath.rmdir()
