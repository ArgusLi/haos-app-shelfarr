#!/usr/bin/env bash
# Read /data/options.json directly with jq (always written by the Supervisor) and export the
# env consumed by the banner, the storage script, and Shelfarr's upstream entrypoint.
# Reading the file directly (rather than bashio::config, which calls the Supervisor API) keeps
# the scripts portable and testable outside Home Assistant.
OPTIONS_FILE="/data/options.json"

get_opt() {
  # get_opt <key> <default>
  local value=""
  [ -r "$OPTIONS_FILE" ] && value="$(jq -r --arg k "$1" '.[$k] // empty' "$OPTIONS_FILE")"
  printf '%s' "${value:-$2}"
}

export PUID="$(get_opt PUID 0)"
export PGID="$(get_opt PGID 0)"
export TZ="$(get_opt TZ UTC)"
export SOLID_QUEUE_IN_PUMA=1

export AUDIOBOOKS_PATH="$(get_opt audiobooks_path /share/shelfarr/audiobooks)"
export EBOOKS_PATH="$(get_opt ebooks_path /share/shelfarr/ebooks)"
export DOWNLOADS_PATH="$(get_opt downloads_path /share/shelfarr/downloads)"

RAILS_MASTER_KEY="$(get_opt RAILS_MASTER_KEY '')"
if [ -n "$RAILS_MASTER_KEY" ]; then
  export RAILS_MASTER_KEY
fi
