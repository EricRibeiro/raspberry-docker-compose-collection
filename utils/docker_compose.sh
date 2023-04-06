#!/bin/false

# This script provides utility functions to deploy and remove Docker containers, networks,
# and volumes defined in a docker-compose.yml file. It is intended to be sourced by other
# scripts that require these functions.

# Get the absolute directory of the script itself
script_dir="$(cd "$(dirname "$0")" && pwd)"

# Public: Deploy Docker containers, networks, and volumes defined in the specified docker-compose.yml file.
#
# This function runs docker compose up -d with the specified environment files and docker-compose.yml file.
function docker_compose_up {
  docker compose --env-file "$script_dir"/../global.env --env-file "$script_dir"/.env --file "$script_dir"/docker-compose.yml up -d
}

# Public: Stop and remove the Docker containers, networks, and volumes defined in the specified docker-compose.yml file.
#
# This function first loads the global and local environment variables using the 'load_env_vars.sh' script from the 'utils' folder.
# Then, it runs the 'docker compose down' command with the specified environment files and docker-compose.yml file.
function docker_compose_down {
  docker compose --env-file "$script_dir"/../global.env --env-file "$script_dir"/.env --file "$script_dir"/docker-compose.yml down
}
