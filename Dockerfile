# build image with
# docker build -t quay.io/bcdev/force-eoap:0.0.14 .
# Push to registery that is available in openEO backend:
# skopeo copy --multi-arch=all --format=oci docker-daemon:quay.io/bcdev/force-eoap:0.0.14 docker://registry.stag.warsaw.openeo.dataspace.copernicus.eu/rand/force-eoap:0.0.14

FROM davidfrantz/force:3.10.04

LABEL FORCE='3.10.04'
LABEL maintainer="David Frantz, University of Trier, Germany"

USER root
RUN mkdir -p /var/cache/apt/archives/partial
RUN apt-get update && apt-get install -yq jq gettext curl xmlstarlet

# Install s5cmd from GitHub releases
RUN curl -L -o s5cmd.tar.gz https://github.com/peak/s5cmd/releases/download/v2.2.2/s5cmd_2.2.2_Linux-64bit.tar.gz && \
    tar -xzf s5cmd.tar.gz && \
    mv s5cmd /usr/local/bin/ && \
    chmod +x /usr/local/bin/s5cmd && \
    rm s5cmd.tar.gz LICENSE README.md CHANGELOG.md 2>/dev/null || true

# Install python tool for staging and its requirements
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN curl -LsSf https://astral.sh/uv/install.sh | env UV_INSTALL_DIR="/opt/uv" sh
ENV PATH=${PATH}:/opt/uv
# Buildkit (untested) version
# --mount requires buildkit
#RUN --mount=type=bind,source=uv.lock,target=/opt/force-python-tools/uv.lock \
#    --mount=type=cache,target=/root/.cache/uv \
#    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
#    uv sync \
#    --locked --project /opt/force-python-tools --python 3.13 --no-dev --no-install-project

# pyproject.toml and uv.lock may be mounted instead of copied using buildkit but are required otherwise.
# See https://docs.astral.sh/uv/guides/integration/docker/#intermediate-layers for instructions
# on optimizing uv installations in Docker
#COPY python/src /opt/force-python-tools/src
#RUN --mount=type=cache,target=/root/.cache/uv \
#    uv sync --locked --project /opt/force-python-tools --no-dev

COPY resources/* /opt/apex-force-wrapper/auxdata/

RUN tar xCf /opt/apex-force-wrapper/auxdata /opt/apex-force-wrapper/auxdata/MGRS_VRT.tar.gz && \
    tar xCf /opt/apex-force-wrapper/auxdata /opt/apex-force-wrapper/auxdata/copernicus-dem-symlinks.tar.gz

# Compatibility version
COPY python/pyproject.toml /opt/force-python-tools/
COPY python/uv.lock /opt/force-python-tools/
RUN uv sync --locked --project /opt/force-python-tools --python 3.13 --no-dev --no-install-project
COPY python/src /opt/force-python-tools/src
RUN uv sync --locked --project /opt/force-python-tools --no-dev

# copy the wrapper scripts to the container
COPY bin/* /opt/apex-force-wrapper/bin/
COPY etc/*.template /opt/apex-force-wrapper/etc/

ENV PATH=$PATH:/opt/apex-force-wrapper/bin
