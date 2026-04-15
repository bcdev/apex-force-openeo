import enum
import json
import logging
from pathlib import Path
from typing import Optional
from urllib import request

import click

from stac_staging.download import download_recursive, download_by_asset
from stac_staging.util import (
    convert_stac_object_to_item_collection,
    read_stac_from_dict,
)

LOGGER = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)


class DownloadMethod(enum.Enum):
    RECURSIVE = enum.auto()
    ASSET = enum.auto()


@click.command()
@click.option("--url", "-u", type=str)
@click.option("--string", "-s", type=str)
@click.option("--output-path", "-o", type=click.Path(), required=True)
@click.option(
    "--method",
    type=click.Choice(DownloadMethod, case_sensitive=False),
    default=DownloadMethod.ASSET,
)
@click.option("--synchronous", is_flag=True)
def download_from_stac(
    url: Optional[str],
    string: Optional[str],
    output_path: Path,
    method: DownloadMethod,
    synchronous: bool,
) -> None:
    """
    Download assets from a STAC item, catalog or item collection
    :param url: URL to the STAC document
    :param string: STAC document as a JSON string
    :param output_path: where to store downloaded data
    :param method: Strategy to download the data. Each method assumes the presence of the mentioned attribute/link.
        ASSET: Download each asset of an item based into a directory structure
        based on its ``file:local_path`` attribute.
        RECURSIVE: Recursively download each item based on its ``enclosure`` link.
    :param synchronous: Whether to download assets one-by-one. Useful for debugging, Default: False
    """
    if (not url and not string) or (url and string):
        raise ValueError(
            f"Exactly one of 'url' or 'string' must be provided, found '{url=} and '{string=}'"
        )
    output_path = Path(output_path)

    if url:
        LOGGER.info(f"Reading from STAC url: {url}")
        with request.urlopen(url) as response:
            stac_obj_or_item_collection_dict = json.load(response)
    else:
        assert string is not None
        LOGGER.info(f"Reading from STAC string")
        stac_obj_or_item_collection_dict = json.loads(string)
    assert stac_obj_or_item_collection_dict is not None

    stac_obj_or_item_collection = read_stac_from_dict(stac_obj_or_item_collection_dict)
    LOGGER.info(f"Found STAC object '{stac_obj_or_item_collection}'")
    items = convert_stac_object_to_item_collection(stac_obj_or_item_collection)
    LOGGER.info(f"Found {len(items)} items")

    # Generate list of items from Catalog/Item/ItemCollection

    match method:
        case DownloadMethod.RECURSIVE:
            download_recursive(items, output_path)
        case DownloadMethod.ASSET:
            download_by_asset(items, output_path, synchronous=synchronous)
