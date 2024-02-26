{
  description = "Config for my computers";

  outputs = rawInputs @ {
    flake-parts,
    nixpkgs,
    ...
  }: let
    privateArgNames = ["hostModuleDir" "hosts" "extraFlakeModules"];
    privateOverrides = nixpkgs.lib.filterAttrs (k: _: (builtins.elem k privateArgNames)) rawInputs;
    # Extra args for private config override
    inputs = builtins.removeAttrs rawInputs privateArgNames;
  in
    flake-parts.lib.mkFlake {inherit inputs;} ({inputs, ...}: {
      imports =
        [
          inputs.lite-system.flakeModule
        ]
        ++ (privateOverrides.extraFlakeModules or []);

      config = {
        lite-system = {
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
          hostModuleDir = privateOverrides.hostModuleDir or ./hosts;

          hosts =
            privateOverrides.hosts
            or {
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

        perSystem = {pkgs, ...}: {
          formatter = pkgs.alejandra;
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
