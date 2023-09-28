let
  libOverride = final: prev: let
    callLibs = file: import file {lib = final;};
  in {
    inherit (callLibs ./flake-util.nix) wrapMkFlake;
    inherit (callLibs ./attrset.nix) deepMergeAttrs;
  };
in
  libOverride
