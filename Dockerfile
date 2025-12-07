FROM python:3.14.1-alpine AS builder
WORKDIR /build
COPY pyproject.toml README.md uv.lock .
COPY src ./src
RUN pip install uv
RUN uv build --clear --wheel --package k8s_service_updater

FROM python:3.14.1-alpine AS final
LABEL org.opencontainers.image.source=https://github.com/cfgmanager/k8s-service-updater
LABEL org.opencontainers.image.description="K8s Service Updater with NAT GW IP"
# SPDX identifiers - https://spdx.org/licenses/
LABEL org.opencontainers.image.licenses=Apache-2.0

RUN --mount=type=bind,from=builder,source=/build/dist,target=/dist \
  pip install $(find /dist -name '*.whl' -print)
RUN ls -la /
RUN which serviceupdater