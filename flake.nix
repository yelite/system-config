{
  description = "Config for my computers";

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} ({
      inputs,
      flake-parts-lib,
      ...
    }: let
      baseModule = flake-parts-lib.importApply ./base.nix {localInputs = inputs;};
    in {
      imports = [
        inputs.lite-system.flakeModule
        baseModule
      ];

      config = {
        flake.flakeModule = baseModule;
        lite-system = {
          hostModuleDir = ./hosts;

          hosts = {
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
    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "github:nix-community/nur-combined?dir=repos/rycee/pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
