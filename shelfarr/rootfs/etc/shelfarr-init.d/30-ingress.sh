#!/usr/bin/env bash
# Configure the nginx ingress proxy. Rails already serves under RAILS_RELATIVE_URL_ROOT
# (set in the Dockerfile); this renders the nginx config from the live ingress values
# and starts nginx in the background. Failure here must NOT take down the app — the
# direct port keeps working regardless.
BASE_PATH="${RAILS_RELATIVE_URL_ROOT:-/shelfarr}"

# Ingress params from the Supervisor; env overrides allow testing without HA.
ingress_entry="${INGRESS_ENTRY:-}"
ingress_port="${INGRESS_PORT_OVERRIDE:-}"
ingress_iface="${INGRESS_IFACE_OVERRIDE:-}"

[ -z "$ingress_entry" ] && ingress_entry="$(bashio::addon.ingress_entry 2>/dev/null || true)"
[ -z "$ingress_port" ] && ingress_port="$(bashio::addon.ingress_port 2>/dev/null || true)"
[ -z "$ingress_iface" ] && ingress_iface="$(bashio::addon.ip_address 2>/dev/null || true)"

: "${ingress_port:=8099}"
: "${ingress_iface:=0.0.0.0}"

if [ -z "$ingress_entry" ]; then
  bashio::log.warning "Ingress entry unavailable; skipping ingress proxy (direct port still works)."
  return 0 2>/dev/null || exit 0
fi

# nginx ip_address from bashio includes a /netmask suffix (e.g. 172.30.33.11/23); strip it.
ingress_iface="${ingress_iface%%/*}"

template="/etc/nginx/ingress.conf.template"
output="/etc/nginx/conf.d/ingress.conf"
sed -e "s|%%interface%%|${ingress_iface}|g" \
    -e "s|%%port%%|${ingress_port}|g" \
    -e "s|%%ingress_entry%%|${ingress_entry}|g" \
    -e "s|%%base_path%%|${BASE_PATH}|g" \
    "$template" > "$output"

if nginx -t >/dev/null 2>&1; then
  nginx
  bashio::log.info "Ingress proxy started on ${ingress_iface}:${ingress_port} (entry ${ingress_entry}, base ${BASE_PATH})"
else
  bashio::log.warning "nginx config test failed; ingress disabled (direct port still works):"
  nginx -t 2>&1 | sed 's/^/  /' || true
fi
