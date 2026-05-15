from importlib.metadata import version, PackageNotFoundError

try:
    __version__ = version("force-python-utils")
except PackageNotFoundError as e:
    pass
