ARG BUILD_FROM
FROM ${BUILD_FROM}

USER root
ARG BASHIO_VERSION="0.16.2"
RUN apt-get update \
  && apt-get install -y --no-install-recommends jq curl tzdata ca-certificates nginx \
  && mkdir -p /tmp/bashio \
  && curl -L -s "https://github.com/hassio-addons/bashio/archive/refs/tags/v${BASHIO_VERSION}.tar.gz" \
       | tar -xzf - --strip-components=1 -C /tmp/bashio \
  && mv /tmp/bashio/lib /usr/lib/bashio \
  && ln -s /usr/lib/bashio/bashio /usr/bin/bashio \
  && rm -f /etc/nginx/sites-enabled/default \
  && rm -rf /tmp/bashio /var/lib/apt/lists/*

# Serve under a fixed base path so the nginx ingress layer can map it onto the
# dynamic Home Assistant ingress entry (mirrors Alexbelgium's *arr add-ons).
ENV SOLID_QUEUE_IN_PUMA=1
ENV RAILS_RELATIVE_URL_ROOT=/shelfarr

COPY rootfs /
RUN chmod a+x /ha-entrypoint.sh /etc/shelfarr-init.d/*.sh

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=5 \
  CMD curl -fsS http://127.0.0.1:80/shelfarr/up || exit 1

ENTRYPOINT ["/ha-entrypoint.sh"]
CMD ["./bin/thrust", "./bin/rails", "server"]
