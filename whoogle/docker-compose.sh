#!/usr/bin/env bash
set -e

# This script is designed to deploy, stop, and remove Whoogle containers. It differs from the other scripts in that it does not
# have to create a Docker volume directory, as it is not used by the Whoogle containers. Therefore, it can go without the added complexity.
function main {
  local -r command="$1"
  local -r script_dir="$2"

  if [ "$command" == "up" ]; then
    docker compose --env-file "$script_dir"/../global.env --env-file "$script_dir"/.env up -d
  elif [ "$command" == "down" ]; then
    docker compose --env-file "$script_dir"/../global.env --env-file "$script_dir"/.env down
  else
    printf '%s\n' "Invalid command. Use 'up' or 'down'."
    exit 1
  fi
}

command="${1:-'up'}"
script_dir="$(cd "$(dirname "$0")" && pwd)"
main "$command" "$script_dir"
