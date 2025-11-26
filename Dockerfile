# build image with
# docker build -t quay.io/bcdev/force-eoap:0.0.2 .

FROM davidfrantz/force

LABEL FORCE='3.8.00'
LABEL maintainer="David Frantz, University of Trier, Germany"

USER root
RUN mkdir -p /var/cache/apt/archives/partial
RUN apt-get update && apt-get install -yq jq gettext python3
RUN pip3 install s5cmd

# copy the wrapper script to the container
COPY resources/force-level2-wrapper.sh /opt/apex-force-wrapper/bin/
COPY resources/*.template /opt/apex-force-wrapper/etc/

ENV PATH=$PATH:/opt/force-wrapper/bin
