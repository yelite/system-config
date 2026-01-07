{
  description = "Config for my computers";

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} (
      {
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
                  (inputs.get-flake ./overlays/neovim).overlay
                  (inputs.get-flake ./overlays/fish).overlay
                  (import ./overlays/extra-pkgs)
                  inputs.niri.overlays.niri
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
      in {imports = [module ./shell.nix];}
    );

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    quickwit-nixpkgs.url = "github:nixos/nixpkgs?rev=18536bf04cd71abd345f9579158841376fdd0c5a";
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
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
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
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    virby = {
      url = "github:quinneden/virby-nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
