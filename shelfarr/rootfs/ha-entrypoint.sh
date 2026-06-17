#!/usr/bin/env bash
set -e

source /usr/lib/bashio/bashio.sh

# Run setup scripts in order; sourced so their exported env persists into exec below.
for script in /etc/shelfarr-init.d/*.sh; do
  [ -r "$script" ] && source "$script"
done

# Hand off to Shelfarr's own entrypoint with the original CMD ("$@").
exec /rails/bin/docker-entrypoint "$@"
