toplevel @ {
  inputs,
  lib,
  flake-parts-lib,
  withSystem,
  ...
}: let
  inherit
    (builtins)
    listToAttrs
    attrNames
    attrValues
    foldl'
    length
    filter
    ;
  inherit
    (lib)
    mkOption
    mapAttrs
    types
    recursiveUpdateUntil
    isDerivation
    ;
  inherit
    (flake-parts-lib)
    mkPerSystemOption
    ;
  cfg = toplevel.config.lite-system;
  hostConfigType = types.submodule {
    options = {
      system = mkOption {
        type = types.str;
      };
    };
  };
  overlayType = types.uniq (types.functionTo (types.functionTo (types.lazyAttrsOf types.unspecified)));
  builderOptionType = types.submodule {
    options = {
      darwin = mkOption {
        description = ''
          The builder function for darwin system.
        '';
        type = types.functionTo types.attrs;
        default = inputs.darwin.lib.darwinSystem;
      };
      nixos = mkOption {
        description = ''
          The builder function for NixOS system.
        '';
        type = types.functionTo types.attrs;
        default = inputs.nixpkgs.lib.nixosSystem;
      };
    };
  };
  nixpkgsOptionType = types.submodule {
    options = {
      nixpkgs = mkOption {
        type = types.path;
        default = inputs.nixpkgs;
      };
      config = mkOption {
        default = {};
        type = types.attrs;
      };
      overlays = mkOption {
        default = [];
        type = types.uniq (types.listOf overlayType);
      };
      exportPackagesInOverlays = mkOption {
        default = true;
        type = types.bool;
      };
      setPerSystemPkgs = mkOption {
        default = true;
        type = types.bool;
      };
    };
  };
  overlayPackageNames = let
    overlay = lib.composeManyExtensions cfg.nixpkgs.overlays;
  in
    attrNames (overlay null null);
  makeSystemConfig = hostName: hostConfig:
    withSystem hostConfig.system ({liteSystemPkgs, ...}: let
      hostPlatform = liteSystemPkgs.stdenv.hostPlatform;
      builderArgs = {
        specialArgs = {
          inherit inputs hostPlatform;
        };
        modules = [
          "${cfg.hostModuleDir}/${hostName}"
          cfg.systemModule
          {
            nixpkgs.pkgs = liteSystemPkgs;
            networking.hostName = hostName;
          }
        ];
      };
    in
      if hostPlatform.isLinux
      then {
        nixosConfigurations.${hostName} = cfg.builder.nixos builderArgs;
      }
      else if hostPlatform.isDarwin
      then {darwinConfigurations.${hostName} = cfg.builder.darwin builderArgs;}
      else throw "Not supported system type ${hostPlatform.system}");
  systemAttrset = let
    # Merge the first two levels
    mergeSysConfig = a: b: recursiveUpdateUntil (path: _: _: (length path) > 2) a b;
    sysConfigAttrsets = attrValues (mapAttrs makeSystemConfig cfg.hosts);
  in
    foldl' mergeSysConfig {} sysConfigAttrsets;
in {
  options = {
    lite-system = mkOption {
      type = types.submodule {
        options = {
          nixpkgs = mkOption {
            description = ''
              Config for nixpkgs used by system configurations.
            '';
            type = nixpkgsOptionType;
            default = {};
          };

          hosts = mkOption {
            description = ''
              Host configurations
            '';
            type = types.attrsOf hostConfigType;
            default = {};
          };

          builder = mkOption {
            type = builderOptionType;
            default = {};
          };

          systemModule = mkOption {
            description = ''
              The system module that is imported by all hosts.
            '';
            type = types.path;
          };

          hostModuleDir = mkOption {
            description = ''
              The directory that contains host modules.
            '';
            type = types.path;
          };
        };
      };
      default = {};
    };

    perSystem = mkPerSystemOption ({
      system,
      liteSystemPkgs,
      ...
    }: {
      _file = ./.;
      config = let
        pkgs = import cfg.nixpkgs.nixpkgs {
          inherit system;
          overlays = cfg.nixpkgs.overlays;
          config = cfg.nixpkgs.config;
        };
      in {
        _module.args.pkgs = lib.mkIf cfg.nixpkgs.setPerSystemPkgs pkgs;
        _module.args.liteSystemPkgs = lib.mkOptionDefault pkgs;

        packages = let
          selectPkg = name: {
            inherit name;
            value = liteSystemPkgs.${name} or null;
          };
          isValidPackageEntry = e: isDerivation e.value;
          overlayPackageEntries = map selectPkg overlayPackageNames;
          validOverlayPackageEntries = filter isValidPackageEntry overlayPackageEntries;
          overlayPackages = listToAttrs validOverlayPackageEntries;
        in
          lib.mkIf cfg.nixpkgs.exportPackagesInOverlays overlayPackages;
      };
    });
  };
  config = {
    # Setting the systems to cover all configured hosts
    systems = lib.unique (attrValues (mapAttrs (_: v: v.system) cfg.hosts));

    flake = systemAttrset;
  };
}
