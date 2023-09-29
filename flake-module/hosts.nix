toplevel @ {
  inputs,
  lib,
  withSystem,
  ...
}: let
  inherit
    (builtins)
    attrValues
    foldl'
    length
    ;
  inherit
    (lib)
    mkOption
    mapAttrs
    types
    recursiveUpdateUntil
    ;
  hostConfigType = types.submodule {
    options = {
      system = mkOption {};
    };
  };
  getSystemAttrs = system:
    if (lib.hasSuffix "linux" system)
    then {
      configAttrName = "nixosConfigurations";
      builder = inputs.nixpkgs.lib.nixosSystem;
      hmModule = inputs.hm.nixosModule;
    }
    else if (lib.hasSuffix "darwin" system)
    then {
      configAttrName = "darwinConfigurations";
      builder = inputs.darwin.lib.darwinSystem;
      hmModule = inputs.hm.darwinModule;
    }
    else throw "Not supported system type ${system}";
  makeSysConfigAttrset = hostName: hostConfig: let
    inherit (getSystemAttrs hostConfig.system) configAttrName builder hmModule;
  in {
    ${configAttrName}.${hostName} = withSystem hostConfig.system ({pkgs, ...}:
      builder {
        specialArgs = {
          inherit inputs;
          hostPlatform = inputs.nixpkgs.lib.systems.elaborate "x86_64-linux";
        };
        modules = [
          "${inputs.self}/hosts/${hostName}"
          "${inputs.self}/modules"
          hmModule
          {
            nixpkgs.pkgs = pkgs;
          }
        ];
      });
  };
  # Merge the first two levels
  mergeSysConfig = a: b: recursiveUpdateUntil (path: _: _: (length path) > 2) a b;
  sysConfigAttrsets = attrValues (mapAttrs makeSysConfigAttrset toplevel.config.hosts);
in {
  options = {
    hosts = mkOption {
      description = ''
        Host configurations
      '';
      type = types.attrsOf hostConfigType;
      default = {};
    };
  };
  config = {
    # Setting the systems to cover all configured hosts
    systems = lib.unique (attrValues (mapAttrs (_: v: v.system) toplevel.config.hosts));
    flake = foldl' mergeSysConfig {} sysConfigAttrsets;
  };
}
