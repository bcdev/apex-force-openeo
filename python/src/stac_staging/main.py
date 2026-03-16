from pathlib import Path
import asyncio

import click
import pystac
import stac_asset
from stac_asset import blocking


@click.command()
@click.option("--url", "-u", type=str, required=True)
@click.option("--output-path", "-o", type=click.Path())
def main(url, output_path: Path):
    output_path = Path(output_path)
    item = pystac.read_file(url)

    # TODO support ItemCollection as well
    if not isinstance(item, pystac.Item):
        raise ValueError(
            f"STAC type '{type(item)}' of '{item}' is not supported. Please pass a valid STAC Item URL"
        )

    output_path.mkdir(parents=True, exist_ok=True)
    tasks = []
    config = stac_asset.Config()
    for asset_key, asset in item.assets.items():
        download_path = output_path / asset.extra_fields["file:local_path"]
        #download_path = output_path / "/".join(asset_key.split("."))
        print(f"Downloading {asset_key} to {download_path}")
        # TODO async download
        blocking.download_asset(asset_key, asset, path=download_path, config=config)


if __name__ == "__main__":
    main()