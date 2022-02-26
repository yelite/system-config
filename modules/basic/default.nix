{ config, pkgs, ... }:
let myConfig = config.myConfig;
in
{
  imports = [
    ./nixos.nix
    ./darwin.nix
    ./darwin-mouse.nix
  ];
}
