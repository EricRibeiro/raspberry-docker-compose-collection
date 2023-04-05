#!/bin/false

# This script is responsible for loading and sourcing both global and local environment variables.
# - Global environment variables are stored in the "global.env" file located at the root of the repository.
# - Local environment variables are found in the ".env" file within the service folder invoking this script.
# Global variables can be used inside the local variable file. For example, if "global.env" contains "TAG=v1.0",
# the ".env" file can use this value as "DOCKER_IMAGE=ericribeiro/dhcp-helper:${TAG}".

# Get the absolute directory of the script itself
script_dir="$(cd "$(dirname "$0")" && pwd)"

# Load global variables
readonly global_env="${script_dir}/../global.env"
[ -f "$global_env" ] || { printf "%s\n" "Please ensure \"global.env.example\" was renamed to \"global.env\" and populated."; exit 1; }
source "$global_env"

# Load local variables
readonly local_env="${script_dir}/.env"
[ -f "$local_env" ] || { printf "%s\n" "Please ensure \"env.example\" was renamed to \".env\" and populated."; exit 1; }
source "$local_env"
