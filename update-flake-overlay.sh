#!/usr/bin/env bash
set -euo pipefail

# Check for required dependencies
command -v nix >/dev/null 2>&1 || { echo "ERROR: nix not found" >&2; exit 1; }

if [ $# -lt 1 ]; then
    echo "Usage: $0 <overlay_name> [command]" >&2
    exit 1
fi

flake_dir=$(dirname "$0")/overlays/$1/
if [ ! -f "$flake_dir/flake.nix" ]; then
    echo "ERROR: Cannot find flake.nix under $flake_dir" >&2
    exit 1
fi

pushd "$flake_dir" > /dev/null

command=${2:-update}
nix flake "$command"

popd > /dev/null
