#!/usr/bin/env bash
set -e

# This script is designed to deploy, stop, and remove Docker containers, networks, and volumes defined in the specified docker-compose.yml file.
# It handles the deployment and management of a Docker environment, setting up the necessary directory, copying configuration files, and running
# the appropriate Docker commands based on the provided arguments ('up' or 'down').

# Public: Main function of the script.
#
# This function accepts the command ('up' or 'down'), a boolean flag to clean stored data, a boolean flag to overwrite stored data,
# a string containing subdirectories, and the owner and group of the created files and directories.
#
# $1 - Command to execute ('up' or 'down').
# $2 - Boolean flag to clean stored data in the Docker volume directory (optional; default: false).
# $3 - Boolean flag to overwrite stored data in the Docker volume directory (optional; default: false).
# $4 - Subdirectories to be created in the Docker volume directory (optional; default: '').
# $5 - Owner of the created files and directories (optional; default: SUDO_USER).
# $6 - Group of the created files and directories (optional; default: SUDO_USER).
function main {
  [ "$EUID" -eq 0 ] || { printf '%s\n' "Please run this script with sudo or as the root user."; exit 1; } # Check if the script is running with "sudo".
  script_dir="$(cd "$(dirname "$0")" && pwd)" # Rely on paths relative to the script instead of the working directory.
  source "$script_dir"/../utils/load_env_vars.sh # Import script to expand "global.env" and ".env"
  source "$script_dir"/../utils/docker_compose.sh # Import script to deploy and remove Docker containers, networks, and volumes
  source "$script_dir"/../utils/prepare_volume_directory.sh # Import script to prepare the Docker volume directory

  local -r command="$1"
  local -r clean_stored_data="$2"
  local -r overwrite_stored_data="$3"
  local -r sub_directories="$4"
  local -r owner="$5"
  local -r group="$6"

  if [ "$command" == "up" ]; then
    prepare_volume_directory "$DOCKER_VOLUME" "$clean_stored_data" "$overwrite_stored_data" "$sub_directories" "$owner" "$group"
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
overwrite_stored_data="${3:-false}"
sub_directories="${4:-}"
owner="${5:-$SUDO_USER}"
group="${6:-$SUDO_USER}"

main "$command" "$clean_stored_data" "$overwrite_stored_data" "$sub_directories" "$owner" "$group"
