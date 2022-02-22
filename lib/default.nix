{
  inherit (import ./flake-util.nix) wrapMkFlake;
  inherit (import ./attrset.nix) deepMergeAttrs;
}
