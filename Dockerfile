# build image with
# docker build -t quay.io/bcdev/force-eoap:0.0.13 .
# Push to registery that is available in openEO backend:
# skopeo copy --multi-arch=all --format=oci docker-daemon:quay.io/bcdev/force-eoap:0.0.13 docker://registry.stag.warsaw.openeo.dataspace.copernicus.eu/rand/force-eoap:0.0.13

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
COPY python/src /opt/force-python-tools/src
COPY python/pyproject.toml /opt/force-python-tools/
COPY python/uv.lock /opt/force-python-tools/
RUN uv --project /opt/force-python-tools sync --python 3.13

# copy the wrapper scripts to the container
COPY bin/* /opt/apex-force-wrapper/bin/
COPY etc/*.template /opt/apex-force-wrapper/etc/
COPY resources/* /opt/apex-force-wrapper/auxdata/

RUN tar xCf /opt/apex-force-wrapper/auxdata /opt/apex-force-wrapper/auxdata/MGRS_VRT.tar.gz && \
    tar xCf /opt/apex-force-wrapper/auxdata /opt/apex-force-wrapper/auxdata/copernicus-dem-symlinks.tar.gz

ENV PATH=$PATH:/opt/apex-force-wrapper/bin
