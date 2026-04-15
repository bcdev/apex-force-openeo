from pathlib import Path
from typing import Optional

import pystac

MEDIA_TYPES = {
    "tif": pystac.MediaType.GEOTIFF,
    "tiff": pystac.MediaType.GEOTIFF,
}


def get_media_type(path: Path) -> Optional[str]:
    return MEDIA_TYPES.get(path.suffix)


def get_asset_key(tile_id: str, asset_path: Path):
    return f"{tile_id}.{asset_path.stem}"


def get_asset_title(tile_id: str, asset_path: Path):
    return f"{tile_id}_{asset_path.stem}".replace("_", " ")
