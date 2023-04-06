#!/usr/bin/env bash

# This script is designed to deploy, stop, and remove Docker containers, networks, and volumes defined in the specified docker-compose.yml file.
# It handles the deployment and management of a Docker environment, setting up the necessary directory, copying configuration files, and running
# the appropriate Docker commands based on the provided arguments ('up' or 'down').

# Public: Prepare the Docker volume directory.
#
# This function creates the specified Docker volume directory if it doesn't exist.
# Then, it copies all the configuration files and dependencies to the directory.
# If the clean_stored_data parameter is true, it also clears stored data in
# the Docker volume directory if the directory exists.
#
# $1 - Docker volume directory.
# $2 - Boolean flag to clean stored data in the Docker volume directory.
function prepare_volume_directory {
  local -r docker_volume="$1"
  local -r clean_stored_data="$2"

  # Create volume directory if it doesn't exist.
  printf '%s\n' "Creating \"$docker_volume\"..."
  mkdir -p "$docker_volume"

  # Clean stored data if the flag is set and the directory exists.
  if [ "$clean_stored_data" = true ] && [ -d "$docker_volume/pihole" ]; then
    printf '%s\n' "Cleaning stored data in \"$docker_volume/pihole\"..."
    rm -rf "$docker_volume/pihole/*"
  fi

  # Copy and replace everything.
  printf '%s\n' "Copying configuration files to \"$docker_volume\"..."
  cp -Rf "$script_dir"/./dnsmasq.d "$docker_volume"
}

# Public: Deploy Docker containers, networks, and volumes defined in the specified docker-compose.yml file.
#
# This function first exports the required environment variables, checks if the
# current user has ownership of the Docker volume directory, and prepares the
# Docker volume directory and the ACME file. If there's any issue, it returns
# an error message and exits. Finally, it runs docker compose up -d.
# If the clean_stored_data parameter is true, it also clears stored data in
# the Docker volume directory if the directory exists.
#
# $1 - Docker volume directory.
# $2 - Boolean flag to clean stored data in the Docker volume directory.
function docker_compose_up {
  local -r docker_volume="$1"
  local -r clean_stored_data="$2"
  prepare_volume_directory "$docker_volume" "$clean_stored_data" || { err_code="$?"; printf '%s\n' "Something went wrong while preparing the docker volume directory"; return "$err_code"; }
  docker compose --env-file "$script_dir"/../global.env --env-file "$script_dir"/.env --file "$script_dir"/docker-compose.yml up -d
}

# Public: Stop and remove the Docker containers, networks, and volumes defined in the specified docker-compose.yml file.
#
# This function first loads the global and local environment variables using the 'load_env_vars.sh' script from the 'utils' folder.
# Then, it runs the 'docker compose down' command with the specified environment files and docker-compose.yml file.
function docker_compose_down {
  docker compose --env-file "$script_dir"/../global.env --env-file "$script_dir"/.env --file "$script_dir"/docker-compose.yml down
}

# Public: Main function of the script.
#
# This function accepts the command ('up' or 'down').
# It then calls the appropriate function based on the command.
#
# $1 - Command to execute ('up' or 'down').
# $2 - Boolean flag to clean stored data in the Docker volume directory (optional; default: false).
function main {
  local -r command="$1"
  local -r clean_stored_data="$2"
  # Required to rely on paths relative to the script instead of the working directory.
  script_dir="$(cd "$(dirname "$0")" && pwd)"

  if [ "$command" == "up" ]; then
    # Check if the script is running with "sudo".
    [ "$EUID" -eq 0 ] || { printf '%s\n' "Please run this script with sudo or as the root user."; exit 1; }
    # Import script to expand "global.env" and ".env"
    source "$script_dir"/../utils/load_env_vars.sh
    docker_compose_up "$DOCKER_VOLUME" "$clean_stored_data"
  elif [ "$command" == "down" ]; then
    docker_compose_down
  else
    printf '%s\n' "Invalid command. Use 'up' or 'down'."
    exit 1
  fi
}

command="${1:-'up'}"
clean_stored_data="${2:-false}"
main "$command" "$clean_stored_data"
