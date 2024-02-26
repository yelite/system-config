{
  description = "Config for my computers";

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} ({
      inputs,
      flake-parts-lib,
      ...
    }: let
      inherit (flake-parts-lib) importApply;
      baseModule = importApply ./base.nix {localInputs = inputs;};
    in {
      imports = [
        baseModule
      ];

      config = {
        flake.flakeModule = baseModule;
        lite-system = {
          hostModuleDir = ./hosts;

          hosts = {
            moonshot = {
              system = "x86_64-linux";
            };

            crater = {
              system = "x86_64-linux";
            };

            lite-octo-macbook = {
              system = "aarch64-darwin";
            };

            lite-home-macbook = {
              system = "x86_64-darwin";
            };
          };
        };
      };
    });

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    lite-system.url = "github:yelite/lite-system";
    get-flake.url = "github:ursi/get-flake";
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util.url = "github:hraban/mac-app-util";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
