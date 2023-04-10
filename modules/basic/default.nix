{ config, ... }:
{
  imports = [
    ./nixos.nix
    ./darwin.nix
    ./darwin-mouse.nix
  ];
}
