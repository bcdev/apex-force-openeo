import asyncio
import logging
import os
import shutil
import subprocess
import tempfile
from collections.abc import Iterable
from pathlib import Path
from typing import Dict, Optional

import aiohttp
import pystac
import stac_asset
from stac_asset import blocking
from stac_asset.client import Clients

from stac_staging.util import unwrap_single_dir_level

LOGGER = logging.getLogger(__name__)
S5CMD = "s5cmd"

S3_ENDPOINT_URL = "S3_ENDPOINT_URL"
AWS_ENDPOINT_URL_S3 = "AWS_ENDPOINT_URL_S3"


def download_by_asset(
    items: Iterable[pystac.Item],
    output_path: Path,
    *,
    synchronous: Optional[bool] = False,
    unwrap_toplevel_dir: bool = True,
):
    """
    Download all assets of the items in ``items``.
    :param items: Iterable of items for which to download the assets
    :param output_path: Base directory where assets should be placed
    :param synchronous: Whether to download synchronously, one by one. (Default: ``False``).
    :param unwrap_toplevel_dir: If True, remove the first level of the directory hierarchy below ``output_path``.
        This is useful, if everything will be contained in a single subdirectory (e.g. continent subdirs from FORCE level2)
    """
    output_path.mkdir(parents=True, exist_ok=True)
    config = stac_asset.Config()
    if synchronous:
        for item in items:
            _download_assets_sync(item.assets, output_path, config)
    else:
        for item in items:
            asyncio.run(_download_assets_async(item.assets, output_path, config))

    if unwrap_toplevel_dir:
        unwrap_single_dir_level(output_path)


def download_recursive(
    items: Iterable[pystac.Item],
    output_path: Path,
    include_toplevel: Optional[bool] = True,
):
    """
    Download the folder structures described by the items using the "recursive" strategy, based on ``s5cmd``'s cp command.
    Downloads the S3 key provided in the assets and all sub-keys.
    :param items: Iterable of items for which to download the assets
    :param output_path: base path where assets should be placed
    :param include_toplevel: Whether to include the toplevel key (e.g. the SAFE archive name) in the output file structure.
        if ``False``, assets from all items will be placed in the same directory, depending on the (default True).
    """
    if shutil.which(S5CMD) is None:
        raise RuntimeError(
            "Recursive download depends on s5cmd. Make sure it is installed."
        )
    if os.getenv(S3_ENDPOINT_URL) is None:
        if os.getenv(AWS_ENDPOINT_URL_S3) is None:
            raise RuntimeError(
                f"Environment variable '{S3_ENDPOINT_URL}' is not set, but required by s5cmd. "
                f"Please set it or the fallback '{AWS_ENDPOINT_URL_S3}'"
            )
        LOGGER.info(
            f"'{S3_ENDPOINT_URL}' not set. Setting '{S3_ENDPOINT_URL}={os.getenv(AWS_ENDPOINT_URL_S3)}'"
        )
        os.environ[S3_ENDPOINT_URL] = os.getenv(AWS_ENDPOINT_URL_S3)

    commands = []

    for item in items:
        enclosure_url = _extract_enclosure_link_url(item)
        if include_toplevel:
            enclosure_url = enclosure_url.rstrip("/")
        commands.append(f"cp {enclosure_url}* {output_path}/")

    with tempfile.NamedTemporaryFile(
        prefix="s5cmd_commands", mode="w+", delete_on_close=False
    ) as tmpfile:
        tmpfile.write("\n".join(commands))
        tmpfile.seek(0)

        LOGGER.info(f"Running s5cmd with commands '{commands}'")
        _run_s5cmd(str(tmpfile.name))


def _download_assets_sync(
    assets: Dict, output_path_base: Path, config: stac_asset.Config
):
    """
    Download assets asynchronously to ``output_path_base/local/path`` where ``local/path`` is determined by
    the ``file:local_path`` attribute of the asset. Fails if ``file:local_path`` is not set.
    Unused, useful for debugging downloads.

    :param assets: Mapping of asset keys to ``pystac.Asset``s
    :param output_path_base: assets will be downloaded to subpaths of this path
    :param config: stac_asset Configuration
    """
    for asset_key, asset in assets.items():
        download_path = (
            output_path_base / asset.extra_fields["file:local_path"]
        ).resolve()
        LOGGER.info(f"Downloading {asset_key} to {download_path} (sync)")
        blocking.download_asset(asset_key, asset, path=download_path, config=config)


async def _download_assets_async(
    assets: Dict,
    output_path_base: Path,
    config: stac_asset.Config,
):
    """
    Download assets asynchronously to ``output_path_base/local/path`` where ``local/path`` is determined by
    the ``file:local_path`` attribute of the asset. Fails if ``file:local_path`` is not set.

    :param assets: Mapping of asset keys to ``pystac.Asset``s
    :param output_path_base: assets will be downloaded to subpaths of this path
    :param config: stac_asset Configuration
    """
    async with aiohttp.ClientSession() as session:
        async with asyncio.TaskGroup() as tg:
            client_cache = Clients(
                config=config,
                clients=[
                    stac_asset.http_client.HttpClient(session, assert_content_type=True)
                ],
            )
            for asset_key, asset in assets.items():
                # TODO fails if no file:local_path attribute exists
                download_path = (
                    output_path_base / asset.extra_fields["file:local_path"]
                ).resolve()
                LOGGER.info(f"Downloading {asset_key} to {download_path} (async)")
                tg.create_task(
                    stac_asset.download_asset(
                        asset_key,
                        asset,
                        path=download_path,
                        config=config,
                        clients=client_cache,
                    )
                )


def _extract_enclosure_link_url(item: pystac.Item) -> str:
    """
    Determine the S3 url of the enclosing SAFE archive. If a link with

    :param item:
    :return:
    """
    enclosure_links = set(l.href for l in item.links if l.rel == "enclosure")

    if len(enclosure_links) > 1:
        raise ValueError(f"Item {item} contains more than one enclosure link")
    if len(enclosure_links) == 0:
        LOGGER.warning(
            f"Item {item} contains no enclosure_link, using fallback method to determine s3 url."
        )
        enclosure_links = {_construct_enclosure_link_from_item(item)}
        LOGGER.info(f"Fallback found enclosure {enclosure_links}")

    url = enclosure_links.pop()
    LOGGER.info(f"Found enclosure link: '{url}' for item '{item}'")
    return url


def _construct_enclosure_link_from_item(item: pystac.Item) -> str:
    """
    Guesses the S3 url of the enclosing SAFE archive from the location of the manifest.safe metadata file.
    Fails (ValueError), if there is no "safe_manifest" asset in the item.
    This function assumes that the file structure of the SAFE archive is preserved on the remote storage
    and may produce incorrect urls if this is not the case.

    :param item: Item for which to determine the location of the SAFE archive
    :return: s3 url to the enclosing SAFE archive
    """
    if "safe_manifest" in item.assets:
        # href: s3://eodata/Sentinel-2/MSI/L1C/2026/04/15/S2A_MSIL1C_20260415T085441_N0512_R107_T37VEC_20260415T105317.SAFE/manifest.safe
        url = item.assets["safe_manifest"].href.removesuffix("manifest.safe")
    else:
        raise ValueError(f"No 'safe_manifest' in {item}")

    return url


def _run_s5cmd(cmd_file: str):
    return subprocess.run([S5CMD, "run", cmd_file])
