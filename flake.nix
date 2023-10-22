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

        homeConfigurations = {
          liteye = {
            myHomeConfig = {
              neovim.enable = true;
              fish.enable = true;
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
  };
}
