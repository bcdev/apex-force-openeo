import enum
import logging
from pathlib import Path

import click
import pystac

from stac_staging.download import download_recursive, download_by_asset
from stac_staging.util import convert_stac_object_to_item_collection

LOGGER = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)


class DownloadMethod(enum.Enum):
    RECURSIVE = enum.auto()
    ASSET = enum.auto()


@click.command()
@click.option("--url", "-u", type=str, required=True)
@click.option("--output-path", "-o", type=click.Path(), required=True)
@click.option(
    "--method",
    type=click.Choice(DownloadMethod, case_sensitive=False),
    default=DownloadMethod.ASSET,
)
@click.option("--synchronous", is_flag=True)
def download_from_stac(
    url: str, output_path: Path, method: DownloadMethod, synchronous: bool
) -> None:
    """
    Download assets from a STAC item, catalog or item collection
    :param url: URL to the STAC document
    :param output_path: where to store downloaded data
    :param method: Strategy to download the data. Each method assumes the presence of the mentioned attribute/link.
        ASSET: Download each asset of an item based into a directory structure
        based on its ``file:local_path`` attribute.
        RECURSIVE: Recursively download each item based on its ``enclosure`` link.
    :param synchronous: Whether to download assets one-by-one. Useful for debugging, Default: False
    :return:
    """
    LOGGER.info(f"Hello there")
    output_path = Path(output_path)
    try:
        stac_obj = pystac.read_file(url)
    except pystac.STACTypeError as _e:
        stac_obj = pystac.ItemCollection.from_file(url)
    LOGGER.info(f"Found STAC object '{stac_obj}' at '{url}'")

    items = convert_stac_object_to_item_collection(stac_obj)

    LOGGER.info(f"Found {len(items)} items")

    # Generate list of items from Catalog/Item/ItemCollection

    match method:
        case DownloadMethod.RECURSIVE:
            download_recursive(items, output_path)
        case DownloadMethod.ASSET:
            download_by_asset(items, output_path)
