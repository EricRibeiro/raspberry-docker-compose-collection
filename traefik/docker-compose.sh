#!/usr/bin/env bash
set -e

# This script is designed to deploy, stop, and remove Docker containers, networks, and volumes defined in the specified docker-compose.yml file.
# It handles the deployment and management of a Docker environment, setting up the necessary directory, copying configuration files, and running
# the appropriate Docker commands based on the provided arguments ('up' or 'down').

# Public: Prepare the Docker volume directory and create the acme.json file.
#
# This function creates the specified Docker volume directory if it doesn't
# exist. Then, it copies all the configuration files and dependencies to said directory
# and sets the ACME file's permission to 600. If the clean_stored_data parameter is true,
# it also clears stored data in the Docker volume directory if the directory exists.
#
# $1 - Docker volume directory.
# $2 - ACME file name.
# $3 - Boolean flag to clean stored data in the Docker volume directory.
function prepare_volume_directory {
  local -r docker_volume="$1"
  local -r acme_file_name="$2"
  local -r clean_stored_data="$3"
  local -r acme_file="$docker_volume/acme/$acme_file_name"

  # Create volume directory if it doesn't exist.
  printf '%s\n' "Creating \"$docker_volume\"..."
  mkdir -p "$docker_volume"

  if [ "$clean_stored_data" = true ]; then
    # Copy and replace everything.
    printf '%s\n' "Copying configuration files to \"$docker_volume\". This will remove existing certificates..."
    cp -Rf "$script_dir"/./traefik/* "$docker_volume"
  else
    # Copy and replace everything but the "acme" folder.
    printf '%s\n' "Copying configuration files, except the "acme" folder, to \"$docker_volume\"..."
    find "$script_dir"/./traefik -mindepth 1 -maxdepth 1 ! -name 'acme' -exec cp -Rf {} "$docker_volume" \;
  fi

  # Set right permission for the ACME file
  chmod 600 "$acme_file"
}

# Public: Main function of the script.
#
# This function accepts the command ('up' or 'down') and a flag to indicate if the "acme" folder should be skipped during
# directory preparation (true to skip, false otherwise). It then calls the appropriate function based on the command.
#
# $1 - Command to execute ('up' or 'down').
# $2 - Boolean flag to clean stored data in the Docker volume directory.
function main {
  [ "$EUID" -eq 0 ] || { printf '%s\n' "Please run this script with sudo or as the root user."; exit 1; }
  script_dir="$(cd "$(dirname "$0")" && pwd)" # Rely on paths relative to the script instead of the working directory.
  source "$script_dir"/../utils/load_env_vars.sh # Import script to expand "global.env" and ".env"
  source "$script_dir"/../utils/docker_compose.sh # Import script to deploy and remove Docker containers, networks, and volumes

  local -r command="$1"
  local -r clean_stored_data="$2"
  local -r acme_file_name="acme.json"

  if [ "$command" == "up" ]; then
    prepare_volume_directory "$DOCKER_VOLUME" "$acme_file_name" "$clean_stored_data"
    docker_compose_up
  elif [ "$command" == "down" ]; then
    docker_compose_down
  else
    printf '%s\n' "Invalid command. Use 'up' or 'down'."
    exit 1
  fi
}

command="${1:-'up'}"
clean_stored_data="${2:-false}" # Useful to avoiding recreating certs and hitting LetsEncrypt API limit.
main "$command" "$clean_stored_data"
