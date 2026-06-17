ARG BUILD_FROM
FROM ${BUILD_FROM}

USER root
ARG BASHIO_VERSION="0.16.2"
RUN apt-get update \
  && apt-get install -y --no-install-recommends jq curl tzdata ca-certificates \
  && mkdir -p /tmp/bashio \
  && curl -L -s "https://github.com/hassio-addons/bashio/archive/refs/tags/v${BASHIO_VERSION}.tar.gz" \
       | tar -xzf - --strip-components=1 -C /tmp/bashio \
  && mv /tmp/bashio/lib /usr/lib/bashio \
  && ln -s /usr/lib/bashio/bashio /usr/bin/bashio \
  && rm -rf /tmp/bashio /var/lib/apt/lists/*

ENV SOLID_QUEUE_IN_PUMA=1

COPY rootfs /
RUN chmod a+x /ha-entrypoint.sh /etc/shelfarr-init.d/*.sh

ENTRYPOINT ["/ha-entrypoint.sh"]
CMD ["./bin/thrust", "./bin/rails", "server"]
