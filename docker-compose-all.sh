#!/usr/bin/env bash

# Check if the script is running as root
if [[ $EUID -ne 0 ]]; then
   printf '%s\n' "This script must be run as root"
   exit 1
fi

set -e

# Check if the first argument is "up" or "down", default to "up" if not provided or invalid
[[ "$1" == "down" ]] && action="down" || action="up"

# Excluded directories
exclude=(
  ".github"
  "utils"
  "calibre"
  "mullvad-browser"
  "pihole"
  "renovate"
  "whoogle"
)

# If the action is 'up', we need to run the action on 'traefik' first
[[ $action == "up" && -d "./traefik" ]] && sudo "./traefik/docker-compose.sh" $action
exclude+=("traefik")

for dir in ./*; do
    if [[ -d "$dir" ]]; then
        # Remove './' from directory name
        dir_name=$(basename "$dir")

        if ! [[ ${exclude[*]} =~ $dir_name ]]; then
            sudo "$dir/docker-compose.sh" $action
        fi
    fi
done

# If the action is 'down', we need to run the action on 'traefik' last
[[ $action == "down" && -d "./traefik" ]] && sudo "./traefik/docker-compose.sh" $action
