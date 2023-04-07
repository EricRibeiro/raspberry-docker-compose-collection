#!/usr/bin/env bash
set -e

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

  # Clean stored data if the flag is set and the directory exists.
  if [ "$clean_stored_data" = true ] && [ -d "$docker_volume" ]; then
    printf '%s\n' "Cleaning stored data in \"$docker_volume\"..."
    rm -rf "$docker_volume"
  fi
}

# Public: Main function of the script.
#
# This function accepts the command ('up' or 'down').
# It then calls the appropriate function based on the command.
#
# $1 - Command to execute ('up' or 'down').
# $2 - Boolean flag to clean stored data in the Docker volume directory (optional; default: false).
function main {
  [ "$EUID" -eq 0 ] || { printf '%s\n' "Please run this script with sudo or as the root user."; exit 1; } # Check if the script is running with "sudo".
  script_dir="$(cd "$(dirname "$0")" && pwd)" # Rely on paths relative to the script instead of the working directory.
  source "$script_dir"/../utils/load_env_vars.sh # Import script to expand "global.env" and ".env"
  source "$script_dir"/../utils/docker_compose.sh # Import script to deploy and remove Docker containers, networks, and volumes

  local -r command="$1"
  local -r clean_stored_data="$2"

  if [ "$command" == "up" ]; then
    prepare_volume_directory "$DOCKER_VOLUME" "$clean_stored_data"
    docker_compose_up
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
