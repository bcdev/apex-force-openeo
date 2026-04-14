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

LOGGER = logging.getLogger(__name__)
S5CMD = "s5cmd"

S3_ENDPOINT_URL = "S3_ENDPOINT_URL"


def download_by_asset(
    items: Iterable[pystac.Item], output_path: Path, synchronous: Optional[bool] = False
):
    output_path.mkdir(parents=True, exist_ok=True)
    config = stac_asset.Config()
    if synchronous:
        for item in items:
            _download_assets_sync(item.assets, output_path, config)
    else:
        for item in items:
            asyncio.run(_download_assets_async(item.assets, output_path, config))


def download_recursive(
    items: Iterable[pystac.Item],
    output_path: Path,
    include_toplevel: Optional[bool] = True,
):
    if shutil.which(S5CMD) is None:
        raise RuntimeError(
            "Recursive download depends on s5cmd. Make sure it is installed."
        )
    if os.getenv(S3_ENDPOINT_URL) is None:
        raise RuntimeError(
            f"Environment variable '{S3_ENDPOINT_URL}' is not set, but required by s5cmd."
        )

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
        if False:
            raise ValueError(f"{tmpfile.read()=}")

        LOGGER.info(f"Running s5cmd with commands '{commands}'")
        _run_s5cmd(str(tmpfile.name))


def _download_assets_sync(
    assets: Dict, output_path_base: Path, config: stac_asset.Config
):
    for asset_key, asset in assets.items():
        download_path = (
            output_path_base / asset.extra_fields["file:local_path"]
        ).resolve()
        LOGGER.info(f"Downloading {asset_key} to {download_path} (sync)")
        # TODO async download
        blocking.download_asset(asset_key, asset, path=download_path, config=config)


async def _download_assets_async(
    assets: Dict, output_path_base: Path, config: stac_asset.Config
):
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


def _extract_enclosure_link_url(item: pystac.Item) -> Optional[str]:
    enclosure_links = set(l.href for l in item.links if l.rel == "enclosure")

    if len(enclosure_links) != 1:
        LOGGER.warning(
            f"Item {item} contains something other than a single enclosure link: '{enclosure_links}', skipping."
        )
        return None

    url = enclosure_links.pop()
    LOGGER.info(f"Found enclosure link: '{url}' for item '{item}'")
    return url


def _run_s5cmd(cmd_file: str):
    return subprocess.run([S5CMD, "run", cmd_file])
