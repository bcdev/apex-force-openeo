from pathlib import Path
import asyncio
from typing import Dict
import logging

import click
import pystac
import stac_asset
from stac_asset import blocking

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

@click.command()
@click.option("--url", "-u", type=str, required=True)
@click.option("--output-path", "-o", type=click.Path())
@click.option("--synchronous", is_flag=True)
def main(url: str, output_path: Path, synchronous: bool):
    output_path = Path(output_path)
    item = pystac.read_file(url)

    # TODO support ItemCollection as well
    if not isinstance(item, pystac.Item):
        raise ValueError(
            f"STAC type '{type(item)}' of '{item}' is not supported. Please pass a valid STAC Item URL"
        )

    output_path.mkdir(parents=True, exist_ok=True)
    config = stac_asset.Config()
    if synchronous:
        download_assets_sync(item.assets, output_path, config)
    else:
        asyncio.run(download_assets_async(item.assets, output_path, config))

def download_assets_sync(assets: Dict, output_path_base: Path, config: stac_asset.Config):
    for asset_key, asset in assets.items():
        download_path = (output_path_base / asset.extra_fields["file:local_path"]).resolve()
        logger.info(f"Downloading {asset_key} to {download_path} (sync)")
        # TODO async download
        blocking.download_asset(asset_key, asset, path=download_path, config=config)

async def download_assets_async(assets: Dict, output_path_base: Path, config: stac_asset.Config):
    tasks = []
    for asset_key, asset in assets.items():
        download_path = (output_path_base / asset.extra_fields["file:local_path"]).resolve()
        logger.info(f"Downloading {asset_key} to {download_path} (async)")
        task = await stac_asset.download_asset(asset_key, asset, path=download_path, config=config)
        tasks.append(task)

    return tasks

if __name__ == "__main__":
    main()