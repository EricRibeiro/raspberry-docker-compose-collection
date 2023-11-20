#!/usr/bin/env bash
set -e

# This script is designed to deploy, stop, and remove Docker containers, networks, and volumes defined in the specified docker-compose.yml file.
# It handles the deployment and management of a Docker environment, setting up the necessary directory, copying configuration files, and running
# the appropriate Docker commands based on the provided arguments ('up' or 'down').
# For more information, see ../utils/main.sh and ../README.md.
[ "$EUID" -eq 0 ] || { printf '%s\n' "Please run this script with sudo or as the root user."; exit 1; } # Check if the script is running with "sudo".
script_dir="$(cd "$(dirname "$0")" && pwd)" # Rely on paths relative to the script instead of the working directory.
source "$script_dir"/../utils/load_env_vars.sh # Import script to expand "global.env" and ".env"
source "$script_dir"/../utils/docker_compose.sh # Import script to deploy and remove Docker containers, networks, and volumes

command="${1:-'up'}"

if [ "$command" == "up" ]; then
  docker_compose_up
elif [ "$command" == "down" ]; then
  docker_compose_down
else
  printf '%s\n' "Invalid command. Use 'up' or 'down'."
  exit 1
fi