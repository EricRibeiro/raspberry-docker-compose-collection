#!/usr/bin/env bash

# Public: Prepare the Traefik Docker volume directory and create the acme.json file.
#
# This function creates the specified Traefik Docker volume directory if it doesn't
# exist. Then, it copies all the configuration files and dependencies to said directory
# and sets the ACME file's permission to 600. If the should_skip_ACME parameter is set
# to 1, the function will skip copying the "acme" folder.
#
# $1 - Traefik Docker volume directory.
# $2 - ACME file name.
# $3 - Flag to indicate if the "acme" folder should be skipped during copy (1 to skip, 0 otherwise).
function prepare_dir {
  local -r docker_volume_traefik="$1"
  local -r acme_file_name="$2"
  local -r should_skip_ACME="$3"
  local -r acme_file="$docker_volume_traefik/acme/$acme_file_name"

  # Create volume directory if it doesn't exist.
  printf '%s\n' "Creating \"$docker_volume_traefik\"..."
  mkdir -p "$docker_volume_traefik"

  if [ "$should_skip_ACME" -eq 1 ]; then
    # Copy and replace everything but the "acme" folder.
    printf '%s\n' "Copying configuration files to \"$docker_volume_traefik\" except the "acme" folder..."
    find "$script_dir"/./traefik -mindepth 1 -maxdepth 1 ! -name 'acme' -exec cp -Rf {} "$docker_volume_traefik" \;
  else
    # Copy and replace everything.
    printf '%s\n' "Copying configuration files to \"$docker_volume_traefik\"..."
    cp -Rf "$script_dir"/./traefik/* "$docker_volume_traefik"
  fi

  # Set right permission for the ACME file
  chmod 600 "$acme_file"
}

# Public: Main function of the script.
#
# This function first exports the required environment variables, checks if the
# current user has ownership of the Docker volume directory, and prepares the
# Docker volume directory and the ACME file. If there's any issue, it returns
# an error message and exits. Finally, it runs `docker compose up -d`.
# If the should_skip_ACME parameter is set to 1, the function will skip copying
# the "acme" folder during the preparation step.
#
# $1 - Flag to indicate if the "acme" folder should be skipped during directory preparation (1 to skip, 0 otherwise).
function main {  
  # Import script to expand "global.env" and ".env"
  source "$script_dir"/../utils/load_env_vars.sh
  local -r should_skip_ACME="$1"
  local -r docker_volume_traefik="$DOCKER_VOLUME_TRAEFIK"  
  local -r acme_file_name="acme.json"
  prepare_dir "$docker_volume_traefik" "$acme_file_name" "$should_skip_ACME" || { err_code="$?"; printf '%s\n' "Something went wrong while prepating the docker volume directory"; return "$err_code"; }
  docker compose --env-file "$script_dir"/../global.env --env-file "$script_dir"/.env --file "$script_dir"/docker-compose.yml up -d
}

# Error-out if script isn't running with sudo
[ "$EUID" -eq 0 ] || { printf '%s\n' "Please run this script with sudo or as the root user."; exit 1; }

# Useful to avoiding recreating certs and hitting LetsEncrypt API limit.
script_dir="$(cd "$(dirname "$0")" && pwd)"
readonly skip_ACME="${SKIP_ACME:-1}"
main "$skip_ACME"
