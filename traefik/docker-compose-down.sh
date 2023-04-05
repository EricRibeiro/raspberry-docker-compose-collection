#!/usr/bin/env bash

# This script is designed to stop and remove the Docker containers, networks, and volumes defined in the specified docker-compose.yml file.
# It first loads the global and local environment variables using the 'load_env_vars.sh' script from the 'utils' folder.
# Then, it runs the 'docker compose down' command with the specified environment files and docker-compose.yml file.
function main {
  local script_dir
  script_dir="$(cd "$(dirname "$0")" && pwd)"
  source "$script_dir"/../utils/load_env_vars.sh
  docker compose --env-file "$script_dir"/../global.env --env-file "$script_dir"/.env --file "$script_dir"/docker-compose.yml down
}

main