#!/usr/bin/env bash
set -euo pipefail

# Check for required dependencies
command -v i3-msg >/dev/null 2>&1 || { echo "ERROR: i3-msg not found" >&2; exit 1; }
command -v jq >/dev/null 2>&1 || { echo "ERROR: jq not found" >&2; exit 1; }

if [ $# -ne 1 ]; then
  echo "Usage: $0 <workspace_name>" >&2
  exit 2
fi

INITIAL_WORKSPACE=$(i3-msg -t get_workspaces \
  | jq '.[] | select(.focused==true).name' \
  | cut -d"\"" -f2)

if [[ "$INITIAL_WORKSPACE" == "$1" ]]; then 
    # If initial workspace is the same as target, do nothing
    exit 0
fi

i3-msg focus output right

current_workspace=$(i3-msg -t get_workspaces \
  | jq '.[] | select(.focused==true).name' \
  | cut -d"\"" -f2)

if [[ "$current_workspace" == "$1" ]]; then 
    # if the target workspace is already on the right, don't switch back to original workspace
    # so that user can trigger this script for the second time to switch to the remotely-opened
    # workspace
    exit 0
fi

output_name=$(i3-msg -t get_workspaces | jq -r '[.[]|select(.focused)][0].output')

i3-msg "workspace $1; move workspace to output $output_name; workspace $INITIAL_WORKSPACE"
