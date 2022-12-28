let libOverride = final: prev:
  {
    inherit (import ./flake-util.nix {
      lib = final;
    }) wrapMkFlake;
    inherit (import ./attrset.nix) deepMergeAttrs;
  };
in
libOverride
