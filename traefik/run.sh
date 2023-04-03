#!/usr/bin/env bash

# Public: Prepare the Traefik Docker volume directory and create the acme.json file.
#
# This function creates the specified Traefik Docker volume directory if it doesn't
# exist. Then, it creates an "acme.json" file inside the directory if it
# doesn't exist already and sets the file's permission to 600.
#
# $1 - Traefik Docker volume directory.
# $2 - ACME file name.
function prepare_dir {
  local -r docker_volume_traefik="$1"
  local -r acme_file_name="$2"
  local -r acme_file="$docker_volume_traefik/$acme_file_name"

  # Create volume directory if it doesn't exist.
  printf '%s\n' "Creating \"$docker_volume_traefik\"..."
  mkdir -p "$docker_volume_traefik"

  # Create "acme.json" if it doesn't exist already.
  [ -f "$acme_file" ] || { printf '%s\n' "Creating \"$acme_file\"..."; printf '%s\n' "{}" > "$acme_file"; chmod 600 "$acme_file"; }
}

# Public: Export environment variables for Docker Compose.
#
# This function exports the environment variables with their respective values.
function export_compose_variables {
  export DOCKER_VOLUME="${DOCKER_VOLUME:-/mnt/docker-volumes}"
  export DOCKER_VOLUME_TRAEFIK="$DOCKER_VOLUME/traefik"
  export CERTIFICATE_EMAIL="ericribeiro@outlook.com.br"
}

# Public: Main function of the script.
#
# This function first exports the required environment variables, checks if the
# current user has ownership of the Docker volume directory, and prepares the
# Docker volume directory and the ACME file. If there's any issue, it returns
# an error message and exits. Finally, it runs `docker compose up -d`.
function main {
  [ "$EUID" -eq 0 ] || { printf '%s\n' "Please run this script with sudo or as the root user."; return 1; }
  
  export_compose_variables

  local -r docker_volume_traefik="$DOCKER_VOLUME_TRAEFIK"
  local -r acme_file_name="acme.json"

  prepare_dir "$docker_volume_traefik" "$acme_file_name" || { err_code="$?"; printf '%s\n' "Something went wrong while prepating the docker volume directory"; return "$err_code"; }

  [ -f "$docker_volume_traefik/$acme_file_name" ] || { printf '%s\n' "The ACME file wasn't created correctly. Please check and try again."; return 1; }
  docker compose up -d
}

main
