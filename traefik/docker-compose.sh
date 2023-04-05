#!/usr/bin/env bash

# This script is designed to deploy Docker containers, networks, and volumes defined in the specified docker-compose.yml file.
# The script first checks if it's running with root privileges, sources the global and local environment variables,
# and prepares the Traefik Docker volume directory with the required configuration files and dependencies.
# The ACME file's permission is set to 600, and the script provides an option to skip copying the "acme" folder.
# Finally, the script runs 'docker compose up -d' with the specified environment files and docker-compose.yml file.

# Public: Prepare the Traefik Docker volume directory and create the acme.json file.
#
# This function creates the specified Traefik Docker volume directory if it doesn't
# exist. Then, it copies all the configuration files and dependencies to said directory
# and sets the ACME file's permission to 600. If the should_skip_acme parameter is set
# to 1, the function will skip copying the "acme" folder.
#
# $1 - Traefik Docker volume directory.
# $2 - ACME file name.
# $3 - Flag to indicate if the "acme" folder should be skipped during copy (1 to skip, 0 otherwise).
function prepare_dir {
  local -r docker_volume_traefik="$1"
  local -r acme_file_name="$2"
  local -r should_skip_acme="$3"
  local -r acme_file="$docker_volume_traefik/acme/$acme_file_name"

  # Create volume directory if it doesn't exist.
  printf '%s\n' "Creating \"$docker_volume_traefik\"..."
  mkdir -p "$docker_volume_traefik"

  if [ "$should_skip_acme" -eq 1 ]; then
    # Copy and replace everything but the "acme" folder.
    printf '%s\n' "Copying configuration files, except the "acme" folder, to \"$docker_volume_traefik\"..."
    find "$script_dir"/./traefik -mindepth 1 -maxdepth 1 ! -name 'acme' -exec cp -Rf {} "$docker_volume_traefik" \;
  else
    # Copy and replace everything.
    printf '%s\n' "Copying configuration files to \"$docker_volume_traefik\"..."
    cp -Rf "$script_dir"/./traefik/* "$docker_volume_traefik"
  fi

  # Set right permission for the ACME file
  chmod 600 "$acme_file"
}

# Public: Deploy Docker containers, networks, and volumes defined in the specified docker-compose.yml file.
#
# This function first exports the required environment variables, checks if the
# current user has ownership of the Docker volume directory, and prepares the
# Docker volume directory and the ACME file. If there's any issue, it returns
# an error message and exits. Finally, it runs docker compose up -d.
# If the should_skip_acme parameter is set to 1, the function will skip copying
# the "acme" folder during the preparation step.
#
# $1 - Flag to indicate if the "acme" folder should be skipped during directory preparation (1 to skip, 0 otherwise).
# $2 - Traefik Docker volume directory.
function docker_compose_up {  
  local -r should_skip_acme="$1"
  local -r docker_volume_traefik="$2"  
  local -r acme_file_name="acme.json"
  prepare_dir "$docker_volume_traefik" "$acme_file_name" "$should_skip_acme" || { err_code="$?"; printf '%s\n' "Something went wrong while prepating the docker volume directory"; return "$err_code"; }
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
# This function accepts the command ('up' or 'down') and a flag to indicate if the "acme" folder should be skipped during
# directory preparation (1 to skip, 0 otherwise). It then calls the appropriate function based on the command.
#
# $1 - Command to execute ('up' or 'down').
# $2 - Flag to indicate if the "acme" folder should be skipped during directory preparation (1 to skip, 0 otherwise).
function main {
  local -r command="$1"
  # Required to rely on paths relative to the script instead of the working directory.
  script_dir="$(cd "$(dirname "$0")" && pwd)"

  if [ "$command" == "up" ]; then
    # Check if the script is running with "sudo".
    [ "$EUID" -eq 0 ] || { printf '%s\n' "Please run this script with sudo or as the root user."; exit 1; }
    # Import script to expand "global.env" and ".env"
    source "$script_dir"/../utils/load_env_vars.sh
    local -r skip_acme="$2"
    local -r docker_volume_traefik="$DOCKER_VOLUME_TRAEFIK"
    docker_compose_up "$skip_acme" "$docker_volume_traefik"
  elif [ "$command" == "down" ]; then
    docker_compose_down
  else
    printf '%s\n' "Invalid command. Use 'up' or 'down'."
    exit 1
  fi
}

command="${1:-'up'}"
skip_acme="${2:-1}" # Useful to avoiding recreating certs and hitting LetsEncrypt API limit.
main "$command" "$skip_acme"
