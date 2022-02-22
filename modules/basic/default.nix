{ config, pkgs, ... }:
let myConfig = config.myConfig;
in
{
  imports = [
    ./darwin.nix
    ./nixos.nix
  ];
}
