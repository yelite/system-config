#!/usr/bin/env bash 

active_workspace=`hyprctl activewindow -j | jq -r '.workspace.name'`

if [[ "$active_workspace" == special:* ]]; then 
    special_workspace=${active_workspace#*special:}
    hyprctl dispatch togglespecialworkspace $special_workspace
fi
