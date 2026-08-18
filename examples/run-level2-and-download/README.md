# Run FORCE level2 and download results

This examples shows a simple use case for running FORCE on CDSE using the openEO API and Python client.
Knowledge of [FORCE](https://force-eo.readthedocs.io/en/latest/) is assumed, familiarity with openEO and the
[Python client](https://open-eo.github.io/openeo-python-client/api.html)  is helpful.

In these examples, FORCE is executed on CDSE and the results downloaded for further processing to the local machine.

> To continue processing with FORCE in the cloud, using the
[Time Series Analysis](https://force-eo.readthedocs.io/en/latest/components/higher-level/tsa/) (TSA) module,
have a look at the advanced [example using the TSA module](../run-level2-and-tsa).

## Notebook

The input products to be processed with FORCE level 2 are specified using STAC documents. It is possible to pass a
STAC Item, Catalog or Collection to the FORCE level 2 process. However, the most common use case is to pass an
Item Collection, as the result of a query to a STAC catalog or collection.
Currently, only the Sentinel-2 L1C collection, which is available
from CDSE (https://stac.dataspace.copernicus.eu/v1/collections/sentinel-2-l1c) is supported.

The example notebook shows the procedure (make a query, run level 2, download and visualize results) using
`pystac_client` to query the STAC collection. You may replace the result of the `pystac_client` query with any other
method of obtaining a STAC document describing your desired inputs.

- [FORCE level 2 using `pystac_client`](FORCE_level2_and_download_external_query.ipynb)