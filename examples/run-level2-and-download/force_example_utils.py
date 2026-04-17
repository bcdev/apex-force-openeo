import matplotlib.pyplot as plt
import contextily as ctx
import geopandas as gpd
from shapely import Polygon

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

def format_list(items, bullet = "\n - "):
    return bullet+bullet.join(items)