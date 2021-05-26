[![License: AGPL v3][uri_license_image]][uri_license]
[![Docs](https://img.shields.io/badge/Docs-Github%20Pages-blue)](https://monogramm.github.io/penpot-exporter/)
[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/Monogramm/docker-penpot-exporter/Docker%20Image%20CI)](https://github.com/Monogramm/docker-penpot-exporter/actions)
[![Docker Automated buid](https://img.shields.io/docker/cloud/build/monogramm/docker-penpot-exporter.svg)](https://hub.docker.com/r/monogramm/docker-penpot-exporter/)
[![Docker Pulls](https://img.shields.io/docker/pulls/monogramm/docker-penpot-exporter.svg)](https://hub.docker.com/r/monogramm/docker-penpot-exporter/)
[![Docker Version](https://images.microbadger.com/badges/version/monogramm/docker-penpot-exporter.svg)](https://microbadger.com/images/monogramm/docker-penpot-exporter)
[![Docker Size](https://images.microbadger.com/badges/image/monogramm/docker-penpot-exporter.svg)](https://microbadger.com/images/monogramm/docker-penpot-exporter)
[![GitHub stars](https://img.shields.io/github/stars/Monogramm/docker-penpot-exporter?style=social)](https://github.com/Monogramm/docker-penpot-exporter)

# **Penpot** Docker image

Docker image for **Penpot**.

🚧 **This image is still in beta!**

## What is **Penpot**

Penpot is The Open-Source prototyping tool.

> [**Penpot**](https://www.penpot.app/)

## Supported tags

[Dockerhub monogramm/docker-penpot-exporter](https://hub.docker.com/r/monogramm/docker-penpot-exporter/)

<!-- >Docker Tags -->

-   main-debian  (`images/main/buster/Dockerfile`)
-   main-debian-slim  (`images/main/buster-slim/Dockerfile`)
-   main-alpine main  (`images/main/alpine/Dockerfile`)
-   develop-debian  (`images/develop/buster/Dockerfile`)
-   develop-debian-slim  (`images/develop/buster-slim/Dockerfile`)
-   develop-alpine develop  (`images/develop/alpine/Dockerfile`)
-   1.6.1-alpha-debian 1.6-debian  (`images/1.6/buster/Dockerfile`)
-   1.6.1-alpha-debian-slim 1.6-debian-slim  (`images/1.6/buster-slim/Dockerfile`)
-   1.6.1-alpha-alpine 1.6-alpine 1.6.1-alpha 1.6  (`images/1.6/alpine/Dockerfile`)
-   1.5.4-alpha-debian 1.5-debian debian  (`images/1.5/buster/Dockerfile`)
-   1.5.4-alpha-debian-slim 1.5-debian-slim debian-slim  (`images/1.5/buster-slim/Dockerfile`)
-   1.5.4-alpha-alpine 1.5-alpine alpine 1.5.4-alpha 1.5 latest  (`images/1.5/alpine/Dockerfile`)

<!-- <Docker Tags -->

## How to run this image

You can use the example `docker-compose.yml` at the root of the project to start a local Penpot instance.
Feel free to update the content of `.env` to your needs.

### Auto configuration via environment variables

The exporter supports dynamic configuration through environment variables.
Checkout Penpot documentation to get the list and their behavior: <https://github.com/penpot/penpot/blob/develop/docs/05-Configuration-Guide.md#backend>

## Questions / Issues

If you got any questions or problems using the image, please visit our [Github Repository](https://github.com/Monogramm/docker-penpot-exporter) and write an issue.

[uri_license]: http://www.gnu.org/licenses/agpl.html

[uri_license_image]: https://img.shields.io/badge/License-AGPL%20v3-blue.svg
