{
  description = "Config for my home computers";

  outputs = { self, nixpkgs, utils, fenix, darwin, ... }@inputs:
    let
      libOverride = import ./lib;
      myLib = nixpkgs.lib.extend libOverride;
      mkFlake = myLib.wrapMkFlake {
        inherit (utils.lib) mkFlake;
        homeManager = inputs.hm;
      };
    in
    mkFlake
      {
        inherit self inputs;

        supportedSystems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];

        channelsConfig.allowUnfree = true;

        # TODO: Reevaluate the wayland on Nvidia to see if the flickering problem is solved
        sharedOverlays = [
          self.overlay
          fenix.overlays.default
          inputs.neovim-nightly-overlay.overlay
          inputs.extra-neovim-plugins.overlay
          # inputs.nixpkgs-wayland.overlay
          (final: prev: {
            # rename the script of fup-repl from flake-utils-plus 
            my-fup-repl = final.fup-repl.overrideAttrs (old: {
              buildCommand = old.buildCommand + ''
                mv $out/bin/repl $out/bin/fup-repl
              '';
            });
          })
        ];

        channels.nixpkgs-darwin = {
          input = inputs.nixpkgs;
          overlaysBuilder = channels: [
            (import ./overlays/darwin-patches)
          ];
        };

        hosts = {
          moonshot = { };

          lite-octo-macbook = {
            system = "aarch64-darwin";
            output = "darwinConfigurations";
            builder = darwin.lib.darwinSystem;
            channelName = "nixpkgs-darwin";
          };
        };


        overlay = import ./overlays/extra-pkgs;
        overlays = utils.lib.exportOverlays {
          inherit (self) pkgs inputs;
        };

        outputsBuilder = channels:
          let
            pkgs = channels.nixpkgs;
          in
          {
            packages = utils.lib.exportPackages self.overlays channels;
            devShells.nvim-config = import ./modules/programs/neovim/dev-shell.nix pkgs;
          };
      };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hm = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    extra-neovim-plugins = {
      url = "path:./flakes/extra-neovim-plugins";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fish-plugins = {
      url = "path:./flakes/fish-plugins";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
