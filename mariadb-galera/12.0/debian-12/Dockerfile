# Copyright Vcnngr
# Based on Bitnami work - Copyright Broadcom, Inc.
# SPDX-License-Identifier: APACHE-2.0

FROM docker.io/vcnngr/minideb:bookworm

ARG DOWNLOADS_URL="minio.vcnngr.it/vcnngr-binaries"
ARG TARGETARCH

LABEL org.opencontainers.image.base.name="docker.io/vcnngr/minideb:bookworm" \
      org.opencontainers.image.created="2025-10-06T00:00:00Z" \
      org.opencontainers.image.description="Application packaged by Vcnngr" \
      org.opencontainers.image.documentation="https://github.com/vcnngr/containers/tree/main/vcnngr/mariadb-galera/README.md" \
      org.opencontainers.image.source="https://github.com/vcnngr/containers/tree/main/vcnngr/mariadb-galera" \
      org.opencontainers.image.title="mariadb-galera" \
      org.opencontainers.image.vendor="Vcnngr" \
      org.opencontainers.image.version="12.0.2"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl iproute2 ldap-utils libaio1 libaudit1 libcap-ng0 libcrypt1 libgcc-s1 libicu72 libldap-common liblzma5 libncurses6 libpam-ldapd libpam0g libssl3 libstdc++6 libtinfo6 libxml2 nslcd procps psmisc rsync socat zlib1g
RUN --mount=type=secret,id=downloads_url \
    DOWNLOADS_URL=$(cat /run/secrets/downloads_url 2>/dev/null || echo "${DOWNLOADS_URL}") ; \
    mkdir -p /tmp/vcnngr/pkg/cache/ /opt/vcnngr ; cd /tmp/vcnngr/pkg/cache/ || exit 1 ; \
    COMPONENTS=( \
      "ini-file/ini-file-1.4.9-1-linux-${OS_ARCH}-debian-12" \
      "mariadb/mariadb-12.0.2-0-linux-${OS_ARCH}-debian-12" \
    ) ; \
    for COMPONENT in "${COMPONENTS[@]}"; do \
      BASENAME=$(basename ${COMPONENT}) ; \
      if [ ! -f "${BASENAME}.tar.gz" ]; then \
        curl -SsLf "https://${DOWNLOADS_URL}/${COMPONENT}.tar.gz" -o "${BASENAME}.tar.gz" ; \
        curl -SsLf "https://${DOWNLOADS_URL}/${COMPONENT}.tar.gz.sha256" -o "${BASENAME}.tar.gz.sha256" ; \
      fi ; \
      sha256sum -c "${BASENAME}.tar.gz.sha256" ; \
      tar -zxf "${BASENAME}.tar.gz" -C /opt/vcnngr --strip-components=2 --no-same-owner ; \
      rm -rf "${BASENAME}".tar.gz{,.sha256} ; \
    done
RUN apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/vcnngr
RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true
RUN mkdir /docker-entrypoint-initdb.d
RUN uninstall_packages curl

COPY rootfs /
RUN /opt/vcnngr/scripts/mariadb-galera/postunpack.sh
ENV APP_VERSION="12.0.2" \
    VCNNGR_APP_NAME="mariadb-galera" \
    IMAGE_REVISION="0" \
    PATH="/opt/vcnngr/common/bin:/opt/vcnngr/mariadb/bin:/opt/vcnngr/mariadb/sbin:/opt/vcnngr/common/sbin:$PATH"

EXPOSE 3306 4444 4567 4568

USER 1001
ENTRYPOINT [ "/opt/vcnngr/scripts/mariadb-galera/entrypoint.sh" ]
CMD [ "/opt/vcnngr/scripts/mariadb-galera/run.sh" ]
