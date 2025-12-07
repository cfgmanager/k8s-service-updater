FROM python:3.14.1-alpine AS builder
WORKDIR /build
COPY src ./src
COPY pyproject.toml .
COPY README.md .
COPY uv.lock .
RUN pip install uv
RUN uv build --clear --wheel --package k8s_service_updater

FROM python:3.14.1-alpine AS final
LABEL org.opencontainers.image.source=https://github.com/cfgmanager/k8s-service-updater
LABEL org.opencontainers.image.description="K8s Service Updater with NAT GW IP"
# SPDX identifiers - https://spdx.org/licenses/
LABEL org.opencontainers.image.licenses=Apache-2.0
COPY --from=builder /build/dist/*.whl /tmp/
RUN pip install $(find /tmp -name '*.whl' -print)
