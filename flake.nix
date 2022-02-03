{
  description = "Config for my home computers";

  outputs = { self, utils, fenix, ... }@inputs: utils.lib.mkFlake
    {
      inherit self inputs;

      supportedSystems = [ "x86_64-linux" ];

      channelsConfig.allowUnfree = true;

      # TODO: Reevaluate the wayland on Nvidia to see if the flickering problem is solved
      channels.nixpkgs.overlaysBuilder = channels: [
        self.overlay
        fenix.overlay
        inputs.extra-neovim-plugins.overlay
        # inputs.nixpkgs-wayland.overlay
      ];

      hosts = {
        moonshot.modules = [
          ./hosts/moonshot
        ];
      };

      hostDefaults.modules = (import ./modules).systemModules ++ [
        inputs.hm.nixosModule
        {
          home-manager = {
            useGlobalPkgs = true;
            extraSpecialArgs = { inherit inputs; };
          };
        }
      ];

      overlay = import ./pkgs { inherit inputs; };
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
    hm = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    extra-neovim-plugins = {
      url = "path:./flakes/extra-neovim-plugins";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
