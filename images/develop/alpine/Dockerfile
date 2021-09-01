FROM monogramm/docker-penpot-builder:develop as builder
# TODO Use official devenv as builder
#FROM penpotapp/devenv:latest as builder

ARG PENPOT_VERSION=develop

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

# Tell Puppeteer to skip installing Chrome. We'll be using the installed package.
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Fetch dependencies (cache them on this step) and build
RUN set -ex; \
    ./scripts/build; \
    ls -al ./target

# Once application has been built, prepare production image
FROM node:14.17.6-alpine3.11

# Add requirements and install application
RUN set -ex; \
    apk update; \
    apk add --no-cache \
        curl \
        gnupg \
        chromium \
        freetype \
        freetype-dev \
        harfbuzz \
        ca-certificates \
        ttf-freefont \
        imagemagick \
        libwebp \
        potrace \
        atk \
        cairo \
        cups \
        dbus \
        expat \
        fontconfig \
        nspr \
        pango \
        xrandr \
        nss \
    ; \
    rm -rf /var/cache/apk/*;

# Tell Puppeteer to skip installing Chrome. We'll be using the installed package.
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

ARG EXTERNAL_UID=5001

# add new user
RUN set -ex; \
    adduser \
        --disabled-password \
        -u "$EXTERNAL_UID" \
        -D penpot \
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
ARG VERSION=develop

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
