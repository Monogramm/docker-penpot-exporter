FROM monogramm/docker-penpot-builder:develop as builder
# TODO Use official devenv as builder
#FROM penpotapp/devenv:latest as builder

ARG PENPOT_VERSION=1.6.1-alpha

# Download source from github
ADD https://github.com/penpot/penpot/archive/${PENPOT_VERSION}.tar.gz /tmp/penpot.tar.gz
# or copy exporter from source and build release
#COPY . /home/penpot/penpot-${PENPOT_VERSION}/exporter

WORKDIR /home/penpot

RUN set -ex; \
    tar -xzf /tmp/penpot.tar.gz --strip=1; \
    rm -f /tmp/penpot.tar.gz;

WORKDIR /home/penpot/exporter

ARG PENPOT_PUBLIC_URI=http://penppot-frontend:80

# Fetch dependencies (cache them on this step) and build
RUN set -ex; \
    ./scripts/build; \
    ls -al ./target

# Once application has been built, prepare production image
FROM node:lts-buster-slim

# Add requirements and install application
RUN set -ex; \
    apt-get -qq update; \
    apt-get -qqy install \
        curl \
        gnupg2 \
        imagemagick \
        webp \
        netpbm \
        potrace \
        gconf-service \
        libasound2 \
        libatk1.0-0 \
        libatk-bridge2.0-0 \
        libcairo2 \
        libcups2 \
        libdbus-1-3 \
        libexpat1 \
        libfontconfig1 \
        libgcc1 \
        libgconf-2-4 \
        libgdk-pixbuf2.0-0 \
        libglib2.0-0 \
        libgtk-3-0 \
        libnspr4 \
        libpango-1.0-0 \
        libpangocairo-1.0-0 \
        libx11-6 \
        libx11-xcb1 \
        libxcb1 \
        libxcb-dri3-0 \
        libxcomposite1 \
        libxcursor1 \
        libxdamage1 \
        libxext6 \
        libxfixes3 \
        libxi6 \
        libxrandr2 \
        libxrender1 \
        libxss1 \
        libxtst6 \
        fonts-liberation \
        libappindicator1 \
        libnss3 \
        libgbm1 \
    ; \
    rm -rf /var/lib/apt/lists/*;

ARG EXTERNAL_UID=5001

# add new user
RUN set -ex; \
    useradd \
        -u "$EXTERNAL_UID" \
        -U \
        penpot \
    ;

# Add penpot as provided by builder and create directories
COPY --chown=penpot:penpot --from=builder /home/penpot /home/penpot

# Add entrypoint
COPY --chown=penpot:penpot ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["start"]

WORKDIR /home/penpot/exporter/target

EXPOSE 6061

# Arguments to label built container
ARG VCS_REF
ARG BUILD_DATE
ARG VERSION=1.6.1-alpha

# Keep track of image version
RUN set -ex; \
    mkdir -p '/app/src'; \
    echo "${VERSION} ${VCS_REF} ${BUILD_DATE}" > '/app/src/.docker-version'

USER penpot

# Container labels (http://label-schema.org/)
# Container annotations (https://github.com/opencontainers/image-spec)
LABEL maintainer="Monogramm maintainers <opensource at monogramm dot io>" \
      product="Penpot" \
      version=$VERSION \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/Monogramm/docker-penpot-exporter" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="Penpot (exporter) - The Open-Source prototyping tool" \
      org.label-schema.description="The open-source solution for design and prototyping" \
      org.label-schema.url="https://www.penpot.app/" \
      org.label-schema.vendor="Penpot" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0" \
      org.opencontainers.image.revision=$VCS_REF \
      org.opencontainers.image.source="https://github.com/Monogramm/docker-penpot-exporter" \
      org.opencontainers.image.created=$BUILD_DATE \
      org.opencontainers.image.title="Penpot (exporter) - The Open-Source prototyping tool" \
      org.opencontainers.image.description="The open-source solution for design and prototyping" \
      org.opencontainers.image.url="https://www.penpot.app/" \
      org.opencontainers.image.vendor="Penpot" \
      org.opencontainers.image.version=$VERSION \
      org.opencontainers.image.authors="Monogramm maintainers <opensource at monogramm dot io>"
