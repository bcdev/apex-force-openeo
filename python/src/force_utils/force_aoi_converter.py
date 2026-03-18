#!/usr/bin/env python3

import click
import sys
import json
import geopandas as gp


@click.command()
@click.argument("feature", type=click.STRING)
@click.argument("shapefile_path", type=click.STRING)
def main(feature: str, shapefile_path: str):
    parsed_feature = json.loads(feature)
    if parsed_feature["type"] == "Feature":
        pass
    elif "west" in parsed_feature and "east" in parsed_feature and "south" in parsed_feature and "north" in parsed_feature:
        w = parsed_feature["west"]
        s = parsed_feature["south"]
        e = parsed_feature["east"]
        n = parsed_feature["north"]
        parsed_feature = {
            "type": "Feature",
            "geometry": {
                "type": "Polygon",
                "coordinates": [[[w,s],[w,n],[e,n],[e,s],[w,s]]]
            }
        }
    else:
        raise ValueError("neither Feature nor bbox provided, but " + feature)
    gdf = gp.GeoDataFrame.from_features({ "type": "FeatureCollection", "features": [parsed_feature]},
                                        crs="EPSG:4326")
    gdf.to_file(shapefile_path)

if __name__ == "__main__":
    feature = sys.argv[1]
    shapefile_path = sys.argv[2]
    main(feature, shapefile_path)