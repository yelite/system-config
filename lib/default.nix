{ lib, ... }:
{
  inherit (import ./flake-util.nix {
    inherit lib;
  }) wrapMkFlake;
  inherit (import ./attrset.nix) deepMergeAttrs;
}
