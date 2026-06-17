#!/usr/bin/env bash
# Cosmetic startup banner. Values come from env exported by 00-options.sh.
bashio::log.blue "-----------------------------------------------------------"
bashio::log.green " Shelfarr add-on"
bashio::log.blue "-----------------------------------------------------------"
bashio::log.info "PUID/PGID : ${PUID}/${PGID}"
bashio::log.info "Timezone  : ${TZ}"
bashio::log.info "Storage   : /config/storage (-> /rails/storage)"
bashio::log.info "Audiobooks: ${AUDIOBOOKS_PATH}"
bashio::log.info "Ebooks    : ${EBOOKS_PATH}"
bashio::log.info "Downloads : ${DOWNLOADS_PATH}"
bashio::log.blue "-----------------------------------------------------------"
