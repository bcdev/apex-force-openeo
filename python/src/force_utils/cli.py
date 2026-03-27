from pathlib import Path
import logging

import click
import pystac

from force_utils.datacube_definition import ForceDataCubeDefinition

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

@click.command()
@click.argument("datacube_root", type=click.Path(exists=True))
@click.option("--output-path", "-o", type=click.Path(exists=True), default=Path.cwd())
@click.option("--id-prefix", "-i", type=str, default="")
def gen_stac(datacube_root, output_path, id_prefix):
    output_path = Path(output_path)
    logger.info(f"Generating STAC catalog and item for {datacube_root}")
    data_cube_def = ForceDataCubeDefinition(datacube_root)
    catalog = data_cube_def.generate_stac(id_prefix=id_prefix)
    catalog.normalize_hrefs(str(output_path))
    logger.info(f"Saving STAC catalog to {output_path.resolve()}")
    catalog.save(dest_href=str(output_path), catalog_type=pystac.CatalogType.SELF_CONTAINED)

@click.command()
@click.argument("data_cube_root", type=click.Path(exists=True))
def compute_datacube_bounding_box(data_cube_root):
    data_cube_def = ForceDataCubeDefinition(data_cube_root)
    bounding_box = data_cube_def.compute_bounding_box()

    print(bounding_box.wkt)
