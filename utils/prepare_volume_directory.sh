#!/bin/false

# Get the absolute directory of the script itself
script_dir="$(cd "$(dirname "$0")" && pwd)"

#!/bin/false

# Public: Prepare the Docker volume directory.
#
# This function creates the specified Docker volume directory and its sub-directories if they don't exist.
# Then, it copies all the configuration files and dependencies to the directory.
# If the clean_stored_data parameter is true, it also clears stored data in
# the Docker volume directory if the directory exists.
# If the overwrite_stored_data parameter is true, it overwrites existing files in the destination folder.
#
# $1 - Docker volume directory.
# $2 - Boolean flag to clean stored data in the Docker volume directory.
# $3 - Boolean flag to overwrite stored data in the Docker volume directory.
# $4 - List of Docker volume directory's sub-directories separated by commas.
# $5 - String with the user that will own the directory.
# $6 - String with the group that will own the directory.
function prepare_volume_directory {
  local -r docker_volume="$1"
  local -r clean_stored_data="$2"
  local -r overwrite_stored_data="$3"
  local -r sub_directories="$4"
  local -r owner="$5"
  local -r group="$6"

  # Clean stored data if the flag is set and the directory exists.
  if [ "$clean_stored_data" = true ] && [ -d "$docker_volume" ]; then
    printf '%s\n' "Cleaning stored data in \"$docker_volume\"..."
    rm -rf "$docker_volume"
  fi

  if [ -n "$sub_directories" ]; then
    local -r temp_dir="$(mktemp -d)"

    # Create volume directory and sub-directories if they don't exist.
    printf '%s\n' "Creating \"$docker_volume\" and sub-directories..."
    IFS=',' read -ra sub_dirs <<< "$sub_directories"
    for sub_dir in "${sub_dirs[@]}"; do mkdir -p "$docker_volume"/"$sub_dir"; done

    # Copy original files to the temporary directory.
    for sub_directory in ${sub_directories//,/ }; do
      cp -R "$script_dir/$sub_directory" "$temp_dir/"
    done

    # Expand variables in the temporary files.
    # Delete files with the .example extension.
    for file in $(find "$temp_dir" -type f); do
      [[ "$file" == *.example ]] && { rm "$file"; continue; }
      envsubst < "$file" > "${file}.expanded"
      mv "${file}.expanded" "$file"
    done

    # Copy files to the Docker volume directory. If the overwrite_stored_data flag is set, overwrite existing files.
    if [ "$overwrite_stored_data" = true ]; then
      printf '%s\n' "Overwriting existing configuration files and copying new files to \"$docker_volume\"..."
      cp -Rf "$temp_dir"/* "$docker_volume/"
    else
      printf '%s\n' "Copying configuration files to \"$docker_volume\" (skipping existing files)..."
      cp -Rn "$temp_dir"/* "$docker_volume/"
    fi

    # Remove the temporary directory.
    rm -rf "$temp_dir"
  else
    # Create volume directory if it doesn't exist.
    printf '%s\n' "Creating \"$docker_volume\"..."
    mkdir -p "$docker_volume"
  fi

  # Change ownership of the Docker volume directory and files to the specified user and group.
  chown -R "${owner}:${group}" "$docker_volume"
  chmod -R a=,a+rX,u+w,g+w "$docker_volume"
}
