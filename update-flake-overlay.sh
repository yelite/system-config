#!/usr/bin/env bash
 
flake_dir=`dirname $0`/overlays/flakes/$1/ 
if [ ! -f $flake_dir/flake.nix ]; then
    echo "Cannot find flake.nix under $flake_dir"
    exit -1
fi

pushd $flake_dir > /dev/null

nix flake update

popd > /dev/null
