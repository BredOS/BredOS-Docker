# syntax=docker/dockerfile:experimental
FROM bredos/bredos:amd64 AS builder

RUN mkdir -p /bredos
COPY . /bredos/
RUN /usr/bin/init-docker
ARG ARCH
ARG TARGETPLATFORM
RUN --security=insecure case "$TARGETPLATFORM" in \
        "linux/amd64") ARCH="x86_64" ;; \
        "linux/arm/v7") ARCH="armv7h" ;; \
        "linux/arm64") ARCH="aarch64" ;; \
        *) echo "Unsupported TARGETPLATFORM: $TARGETPLATFORM" && exit 1 ;; \
    esac && \
    /bredos/build.sh "$ARCH"

FROM scratch

COPY --from=builder /bredos/build/rootfs/ /
SHELL ["/bin/sh", "-c"]
ENV LANG=en_US.UTF-8

RUN { groupadd wheel &> /dev/null || true; } \
    && useradd --create-home --groups wheel bred \
    && chmod +x /usr/bin/init-docker \
    && locale-gen

CMD ["/usr/bin/init-docker"]
