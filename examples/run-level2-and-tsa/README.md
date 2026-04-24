# Run FORCE Level 2 and Time Series Analysis

This example showcases how the ARD cubes produced by FORCE level 2 can be further processed
with the [FORCE Time Series Analysis](https://force-eo.readthedocs.io/en/stable/components/higher-level/tsa/index.html)
(TSA) module.

The TSA process takes in a reference (URL) to the STAC catalog produced by the level 2 process.
The [notebook](FORCE_level2_and_TSA.ipynb) executes TSA twice, using the same level 2 data cube.

> Have a look at the [level 2 examples](../run-level2-and-download) for a more detailed description of the level 2
> process.