{
  description = "Config for my computers";

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} ({
      inputs,
      flake-parts-lib,
      ...
    }: let
      module = {
        imports = [
          inputs.lite-config.flakeModules.default
        ];

        config = {
          flake.flakeModule = module;

          lite-config = {
            nixpkgs = {
              config = {
                allowUnfree = true;
              };
              overlays = [
                inputs.fenix.overlays.default
                (inputs.get-flake ./overlays/neovim).overlay
                (inputs.get-flake ./overlays/fish).overlay
                (import ./overlays/extra-pkgs)
              ];
            };

            systemModules = [./system];
            homeModules = [./home];

            hosts = {
              liteye-mbp = {
                system = "aarch64-darwin";
                hostModule = ./hosts/lite-meta-macbook;
              };
            };

            homeConfigurations = {
              liteye = {
                myConfig = {
                  neovim.enable = true;
                  fish.enable = true;
                };
              };
            };
          };

          perSystem = {pkgs, ...}: {
            formatter = pkgs.alejandra;
          };
        };
      };
    in
      module);

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    lite-config.url = "github:yelite/lite-config";
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
      # It has to be imported as non-flake and use callPackage from our own nixpkgs to
      # create derivations from it. Otherwise plugins with unfree license will refuse to 
      # be evaluated, regardless of the config of our own nixpkgs.
      flake = false;
    };
  };
}
