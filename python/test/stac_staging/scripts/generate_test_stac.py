from datetime import datetime, timezone
from pathlib import Path

import pystac


def generate_stac(asset_dir: Path) -> Path:
    target_dir = asset_dir / "stac"
    target_dir_item = target_dir / "test_item"
    date = datetime(2025, 6, 23, tzinfo=timezone.utc)
    catalog = pystac.Catalog("test_catalog", "Catalog for tests")
    item = pystac.Item(
        "test_item", geometry=None, datetime=date, properties={}, bbox=None
    )
    item.ext.add("file")
    asset_b = pystac.Asset(
        href=str((asset_dir / "b.txt").relative_to(target_dir_item, walk_up=True)),
        title="Asset B",
        media_type="text/plain",
    )
    asset_c = pystac.Asset(
        href=str((asset_dir / "c.txt").relative_to(target_dir_item, walk_up=True)),
        title="Asset C",
        media_type="text/plain",
    )
    asset_b.ext.file.local_path = "b.txt"
    asset_c.ext.file.local_path = "c.txt"

    item.add_asset("b", asset_b)
    item.add_asset("c", asset_c)

    item.links.append(
        pystac.Link(
            rel="enclosure",
            target=str((asset_dir / "enclosure").relative_to(target_dir, walk_up=True)),
            title="Enclosure",
        )
    )

    catalog.add_item(item)
    catalog.normalize_hrefs(str(target_dir))
    catalog.save(
        dest_href=str(target_dir),
        catalog_type=pystac.CatalogType.RELATIVE_PUBLISHED,
    )
    item_collection = pystac.ItemCollection([item])
    item_collection.save_object(str(target_dir / "test_item_collection.json"))
    return target_dir


if __name__ == "__main__":
    asset_dir = Path(__file__).parent.parent / "data"
    assert asset_dir.exists(), f"Asset directory '{asset_dir}' does not exist"
    generate_stac(asset_dir)
