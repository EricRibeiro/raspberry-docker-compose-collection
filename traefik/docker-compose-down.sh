#!/usr/bin/env bash

function main {
  local script_dir
  script_dir="$(cd "$(dirname "$0")" && pwd)"
  source "$script_dir"/../utils/load_env_vars.sh
  docker compose --env-file "$script_dir"/../global.env --env-file "$script_dir"/.env --file "$script_dir"/docker-compose.yml down
}

main