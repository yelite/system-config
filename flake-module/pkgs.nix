toplevel @ {
  lib,
  flake-parts-lib,
  inputs,
  ...
}: let
  inherit
    (builtins)
    attrNames
    listToAttrs
    map
    filter
    ;
  inherit
    (lib)
    mkOption
    types
    isDerivation
    ;
  inherit
    (flake-parts-lib)
    mkPerSystemOption
    ;
  overlayType = types.uniq (types.functionTo (types.functionTo (types.lazyAttrsOf types.unspecified)));
  nixpkgsOptionType = types.submodule {
    options = {
      config = mkOption {
        default = {};
        type = types.attrs;
      };

      overlays = mkOption {
        default = [];
        type = types.uniq (types.listOf overlayType);
      };
    };
  };
  overlayPackageNames = let
    overlay = lib.composeManyExtensions toplevel.config.nixpkgs.overlays;
  in
    attrNames (overlay null null);
in {
  options = {
    nixpkgs = mkOption {
      description = ''
        Config on the global nixpkgs
      '';
      type = nixpkgsOptionType;
      default = {};
    };

    perSystem = mkPerSystemOption ({
      system,
      pkgs,
      ...
    }: {
      _file = ./.;
      config = {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = toplevel.config.nixpkgs.overlays;
          config = toplevel.config.nixpkgs.config;
        };

        packages = listToAttrs (map (name: {
            inherit name;
            value = pkgs.${name};
          })
          (filter (name: isDerivation pkgs.${name}) overlayPackageNames));
      };
    });
  };
}
