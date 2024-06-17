#!/usr/bin/env bash
 
flake_dir=`dirname $0`/overlays/$1/ 
if [ ! -f $flake_dir/flake.nix ]; then
    echo "Cannot find flake.nix under $flake_dir"
    exit -1
fi

pushd $flake_dir > /dev/null

command=$2
nix flake ${command:=update}

popd > /dev/null
