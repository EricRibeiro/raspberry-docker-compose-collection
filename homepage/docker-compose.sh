#!/usr/bin/env bash
set -e

# This script is designed to deploy, stop, and remove Docker containers, networks, and volumes defined in the specified docker-compose.yml file.
# It handles the deployment and management of a Docker environment, setting up the necessary directory, copying configuration files, and running
# the appropriate Docker commands based on the provided arguments ('up' or 'down').
# For more information, see ../utils/main.sh and ../README.md.

command="${1:-'up'}"
clean_stored_data="${2:-false}"
overwrite_stored_data="${3:-false}"
sub_directories="${4:-config,icons,images}"
owner="${5:-$SUDO_USER}"
group="${6:-$SUDO_USER}"

script_dir="$(cd "$(dirname "$0")" && pwd)"
source "$script_dir"/../utils/main.sh # Import script to execute the main function.
main "$command" "$clean_stored_data" "$overwrite_stored_data" "$sub_directories" "$owner" "$group"
