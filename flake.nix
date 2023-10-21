{
  description = "Config for my computers";

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} ({inputs, ...}: {
      imports = [
        inputs.lite-system.flakeModule
        ./flake-modules/formatter.nix
      ];

      config.lite-system = {
        nixpkgs = {
          config = {
            allowUnfree = true;
          };
          overlays = [
            inputs.fenix.overlays.default
            (inputs.get-flake ./overlays/flakes/neovim).overlay
            (inputs.get-flake ./overlays/flakes/fish).overlay
            (import ./overlays/extra-pkgs)
          ];
          # exportPackagesInOverlays = false;
        };

        systemModule = ./system;
        homeModule = ./home;
        hostModuleDir = ./hosts;

        hosts = {
          moonshot = {
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

      config.perSystem = {
        inputs',
        pkgs,
        ...
      }: {
        packages = {
          hm = inputs'.home-manager.packages.default;
          homeConfigurations = pkgs.stdenv.mkDerivation {
            name = "homeConfigurations";
            version = "1.0";
            phases = [];
            passthru = {
              liteye = inputs.home-manager.lib.homeManagerConfiguration {
                inherit pkgs;
                modules = [
                  ./home
                  {
                    home.username = "liteye";
                    home.homeDirectory = "/home/liteye";
                  }
                ];

                extraSpecialArgs = {
                  inherit inputs;
                  hostPlatform = pkgs.stdenv.hostPlatform;
                  pkgs = pkgs;
                  # home.homeDirectory = "/home/liteye";
                };
              };
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
      url = "github:lnl7/nix-darwin/master";
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
  };
}
