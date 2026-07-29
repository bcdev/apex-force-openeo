# Examples

## Modules

- [FORCE Level 2](run-level2-and-download)
- [Time Series Analysis](run-level2-and-tsa)

## How to run the examples

Each example is implemented as a [Jupyter notebook](https://jupyter.org/).
You can read [the rendered examples on Github](https://github.com/bcdev/apex-force-openeo/tree/main/examples).
To run the examples by yourself, it is necessary to set up a Python virtual environment with the necessary dependencies.

Each example provides an environment definition for [pixi](https://pixi.prefix.dev/latest/) and
[conda](https://www.anaconda.com/docs/getting-started/miniconda/main)/[micromamba](https://mamba.readthedocs.io/en/latest/user_guide/micromamba.html).
We recommend the use of pixi or micromamba.


### Pixi

First you need to have [pixi installed](https://pixi.prefix.dev/latest/installation/).

The pixi environment definition is stored in `pixi.toml` and `pixi.lock`.
A special environment (called `examples`) is configured for the examples.

Navigate to the example directory and run pixi on the command line:

```bash
pixi run --environment examples jupyter lab
```

This should open a browser window showing the notebook for the respective example.

### Other package managers

If you would like to use another package manager besides pixi (pip, conda, uv, ...), make sure to install all the
packages listed in pixi.toml in the `examples` feature, plus `jupyterlab` and `openeo`.

```toml
[feature.examples.dependencies]
# install everything listed here
```