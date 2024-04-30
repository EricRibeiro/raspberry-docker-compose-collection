#!/bin/sh -e
# See https://autobrr.com/usage/tips

# Change this to the path of the volume you want to check.
seedVolume="/seed"
# How much space do you want to have free in GB?
minimumSpaceAvailableInGB=100
# Get the available space in the volume.
availableSpaceInGB="$(df -h "$seedVolume" | awk 'END{gsub(/G/, "", $4); print int($4)}')"

# Check if the available space is less than the minimum required.
# If it is, exit with an error.
if [ "$availableSpaceInGB" -le "$minimumSpaceAvailableInGB" ]; then
  echo "Not enough space available in $seedVolume."
  echo "Minimum required: $minimumSpaceAvailableInGB GB."
  echo "Available: $availableSpaceInGB GB."
  exit 1
fi

# If there is enough space, print a message and exit successfully.
echo "There is enough space available in $seedVolume."
echo "Minimum required: $minimumSpaceAvailableInGB GB."
echo "Available: $availableSpaceInGB GB."
exit 0
