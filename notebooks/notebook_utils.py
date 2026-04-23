import matplotlib.pyplot as plt
import contextily as ctx
import geopandas as gpd
from shapely import Polygon
import pystac

def extract_catalog_url_from_job_logs(job_logs) -> str:
    log_with_catalog_url = next(
        iter(
            l.message for l in job_logs if "copy_asset(" in l.message and ("catalogue.json" in l.message or "catalog.json" in l.message)
        )
    )
    catalog_url = log_with_catalog_url.removeprefix("URL: copy_asset(").removesuffix(")")
    return catalog_url


def plot_area_of_interest(
    w, s, e, n, *, 
    large_context=10,
    small_context=1.25,
    color="red",
    linewidth=2,
    title="Spatial Extent",
    figsize=(12, 8),
    show_tick_labels=True,
    ):
    polygon = Polygon([(w, s), (e, s), (e, n), (w, n)])
    gdf = gpd.GeoDataFrame(geometry=[polygon], crs="EPSG:4326")
    fig, axs = plt.subplots(1, 2, figsize=figsize)
    gdf.plot(edgecolor=color, facecolor="none", linewidth=linewidth, ax=axs[0])
    gdf.plot(edgecolor=color, facecolor="none", linewidth=linewidth, ax=axs[1])
    axs[0].set_xlim(w - large_context, e + large_context)
    axs[0].set_ylim(s - large_context, n + large_context)
    axs[1].set_xlim(w - small_context, e + small_context)
    axs[1].set_ylim(s - small_context, n + small_context)
    if not show_tick_labels:
        for ax in axs:
            ax.set_xticks([])
            ax.set_yticks([])
    ctx.add_basemap(axs[0], source=ctx.providers.OpenStreetMap.Mapnik, crs=gdf.crs)
    ctx.add_basemap(axs[1], source=ctx.providers.OpenStreetMap.Mapnik, crs=gdf.crs);
    fig.suptitle(title)
    fig.tight_layout()


def transform_item_collection_to_catalog_with_links(item_collection):
    catalog = pystac.Catalog(
        id="item-collection-catalog",
        description="Catalog from item collection",
    )
    for item in item_collection.items:
        href = item.self_href
        item_link = pystac.Link(
            rel=pystac.RelType.ITEM,
            target=href,
            media_type=pystac.MediaType.GEOJSON,
            title=f"Item {item.id}",
        )
        catalog.add_link(item_link)
    return catalog