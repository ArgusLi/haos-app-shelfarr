# Changelog

## 1.1.1
- Fixed a blank ingress page: nginx/app redirects were being absolutized to the
  internal ingress port (`:8099`), causing the browser to hit an unexposed port
  (connection refused). Redirects are now kept path-only (`absolute_redirect off`)
  and app `Location` headers are rewritten onto the ingress entry (`proxy_redirect`).

## 1.1.0
- Added Home Assistant **ingress** (sidebar) support via an nginx layer that maps a
  fixed base path (`/shelfarr`, set with `RAILS_RELATIVE_URL_ROOT`) onto the dynamic
  ingress entry with `sub_filter` — mirroring Alexbelgium's *arr add-ons.
- Live updates (ActionCable / Turbo Streams) work through ingress (`ingress_stream`),
  with the cable URL advertised under the base path.
- The direct port (5056) is kept as a fallback and now serves under `/shelfarr/`
  (WebUI link and health check updated accordingly).

## 1.0.0
- Initial Shelfarr add-on: direct port 5056 + WebUI link, storage in addon_config,
  libraries under /share/shelfarr.
