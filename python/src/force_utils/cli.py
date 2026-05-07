import logging
from pathlib import Path

import click
import pystac

from force_utils.contributor import (
    FileExtensionMetadataStacContributor,
    ProjExtensionMetadataStacContributor,
    RasterExtensionMetadataStacContributor,
    Level2StacContributor,
)
from force_utils.datacube_definition import ForceDataCubeDefinition
from force_utils.datacube_store import ForceDatacubeStore
from force_utils.force_stac import ForceStacBuilder

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


@click.command()
@click.argument("datacube-root", type=click.Path(exists=True))
@click.option("--output-path", "-o", type=click.Path(exists=True), default=Path.cwd())
@click.option("--item-id", "-i", type=str, default="")
def gen_stac_old(datacube_root, output_path, item_id):
    output_path = Path(output_path)
    logger.info(f"Generating STAC catalog and item for {datacube_root}")
    data_cube_def = ForceDataCubeDefinition(datacube_root)
    catalog = data_cube_def.generate_stac(item_id=item_id)
    catalog.normalize_hrefs(str(output_path))
    logger.info(f"Saving STAC catalog to {output_path.resolve()}")
    catalog.save(
        dest_href=str(output_path), catalog_type=pystac.CatalogType.SELF_CONTAINED
    )


@click.command()
@click.argument("datacube-root", type=click.Path(exists=True))
@click.option("--output-path", "-o", type=click.Path(exists=True), default=Path.cwd())
@click.option("--item-id", "-i", type=str, default="")
@click.option("--validate", is_flag=True)
def gen_stac(datacube_root, output_path, item_id, validate):
    output_path = Path(output_path)
    logger.info(f"Generating STAC catalog and item for {datacube_root}")
    datacube_store = ForceDatacubeStore(datacube_root)
    stac_builder = ForceStacBuilder(
        datacube_store,
        contributors=[
            FileExtensionMetadataStacContributor(),
            ProjExtensionMetadataStacContributor(),
            RasterExtensionMetadataStacContributor(),
            Level2StacContributor(),
        ],
    )
    catalog = stac_builder.generate_stac(item_id=item_id)
    catalog.normalize_hrefs(str(output_path))
    if validate:
        catalog.validate()
    logger.info(f"Saving STAC catalog to {output_path.resolve()}")
    catalog.save(
        dest_href=str(output_path), catalog_type=pystac.CatalogType.SELF_CONTAINED
    )


@click.command()
@click.argument("data_cube_root", type=click.Path(exists=True))
def compute_datacube_bounding_box(data_cube_root):
    data_cube_def = ForceDataCubeDefinition(data_cube_root)
    bounding_box = data_cube_def.compute_bounding_box()

    print(bounding_box.wkt)
