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
    find ./traefik -mindepth 1 -maxdepth 1 ! -name 'acme' -exec cp -Rf {} "$docker_volume_traefik" \;
  else
    # Copy and replace everything.
    printf '%s\n' "Copying configuration files to \"$docker_volume_traefik\"..."
    cp -Rf ./traefik/* "$docker_volume_traefik"
  fi

  # Set right permission for the ACME file
  chmod 600 "$acme_file"
}

# Public: Replace a variable in a YAML file with the value from an environment file.
#
# This function reads the value of a specified variable from an environment file
# and replaces the specified variable in a YAML file with the extracted value.
#
# $1 - Path to the environment file (e.g., cloudflare.env).
# $2 - Path to the YAML file (e.g., traefik.yaml).
# $3 - Variable name in the environment file (e.g., CF_API_EMAIL).
# $4 - Variable name in the YAML file (e.g., $CF_API_EMAIL).
#
# Examples
#
#   replace_cloudflare_email_var "cloudflare.env" "traefik.yaml" "CF_API_EMAIL" "\$CF_API_EMAIL"
#
# Returns nothing.
function replace_yaml_content_with_env_content {
  local -r env_file="$1"
  local -r yaml_file="$2"
  local -r var_name_in_env_file="$3"
  local -r var_name_in_yaml="$4"

  # Read the variable value from the environment file.
  local var_value
  var_value=$(grep "$var_name_in_env_file" "$env_file" | cut -d '=' -f 2) && readonly var_value

  # Replace value in the YAML file with the envinronment file's extracted value.
  sed -i "s/$var_name_in_yaml/$var_value/g" "$yaml_file"
}

# Public: Resolve IP address from a DNS domain and replace a variable in a YAML file.
#
# This function reads the domain value from an environment file, resolves the IP
# address using the ping command, and replaces a specified variable in a YAML
# file with the resolved IP address.
#
# $1 - Environment file path.
# $2 - YAML file path.
# $3 - Variable name in the environment file.
# $4 - Variable name in the YAML file.
#
# Examples
#
#   resolve_ip_from_dns_and_replace_yaml_content "cloudflare.env" "traefik.yaml" "CF_NS_1" "\$CF_NS_1"
#
# Returns nothing.
function resolve_ip_from_dns_and_replace_yaml_content {
  local -r env_file="$1"
  local -r yaml_file="$2"
  local -r var_name_in_env_file="$3"
  local -r var_name_in_yaml="$4"

  # Read the variable value from the environment file.
  local var_value
  var_value=$(grep "$var_name_in_env_file" "$env_file" | cut -d '=' -f 2) && readonly var_value

  # Resolve the IP Address from the DNS.
  local ip_address
  ip_address=$(ping -c 1 "$var_value" | grep -o -E '([0-9]{1,3}\.){3}[0-9]{1,3}' | head -n 1) && readonly ip_address

  # Replace value in the YAML file with the envinronment file's extracted value.
  sed -i "s/$var_name_in_yaml/$ip_address/g" "$yaml_file"
}

# Public: Export environment variables for Docker Compose.
#
# This function exports the environment variables with their respective values.
function export_compose_variables {
  export DOCKER_VOLUME="${DOCKER_VOLUME:-/mnt/docker-volumes}"
  export DOCKER_VOLUME_TRAEFIK="$DOCKER_VOLUME/traefik"
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
  local -r should_skip_ACME="$1"
  
  export_compose_variables
  
  local -r docker_volume_traefik="$DOCKER_VOLUME_TRAEFIK"  
  local -r acme_file_name="acme.json"
  prepare_dir "$docker_volume_traefik" "$acme_file_name" "$should_skip_ACME" || { err_code="$?"; printf '%s\n' "Something went wrong while prepating the docker volume directory"; return "$err_code"; }
  
  local -r cloudflare_env_file="cloudflare.env"
  local -r traefik_yaml_file="$DOCKER_VOLUME_TRAEFIK/traefik.yml"
  local -r email_var_in_env_file="CF_API_EMAIL"
  local -r email_var_in_yaml_file="\$CF_API_EMAIL"
  replace_yaml_content_with_env_content "$cloudflare_env_file" "$traefik_yaml_file" "$email_var_in_env_file" "$email_var_in_yaml_file"
  
  local -r ns_1_in_env_file="CF_NS_1"
  local -r ns_1_in_yaml_file="\$CF_NS_1"
  resolve_ip_from_dns_and_replace_yaml_content "$cloudflare_env_file" "$traefik_yaml_file" "$ns_1_in_env_file" "$ns_1_in_yaml_file"

  local -r ns_2_in_env_file="CF_NS_2"
  local -r ns_2_in_yaml_file="\$CF_NS_2"
  resolve_ip_from_dns_and_replace_yaml_content "$cloudflare_env_file" "$traefik_yaml_file" "$ns_2_in_env_file" "$ns_2_in_yaml_file"

  docker compose up -d
}

# Error-out if script isn't running with sudo
[ "$EUID" -eq 0 ] || { printf '%s\n' "Please run this script with sudo or as the root user."; exit 1; }

# Useful to avoiding recreating certs and hitting LetsEncrypt API limit.
readonly skip_ACME="${SKIP_ACME:-1}"

main "$skip_ACME"
