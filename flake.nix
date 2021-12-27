{
  description = "Config for my home computers";

  outputs = { self, utils, ... }@inputs: utils.lib.mkFlake
    {
      inherit self inputs;

      supportedSystems = [ "x86_64-linux" ];

      channelsConfig.allowUnfree = true;

      # TODO: Reevaluate the wayland on Nvidia to see if the flickering problem is solved
      # channels.nixpkgs.overlaysBuilder = channels: [
      #   inputs.nixpkgs-wayland.overlay
      # ];

      hosts = {
        moonshot.modules = [
          ./hosts/moonshot
          ./modules/desktop.nix
          ./modules/hm-xsession
          ./modules/keyboard-remap
          ./modules/logitech
          {
            home-manager.users.liteye.imports = [
              ./home/gui.nix
              ./hosts/moonshot/home.nix
              ./modules/keyboard-remap/user.nix
            ];
          }
        ];
      };

      hostDefaults.modules = [
        ./modules/basic.nix
        ./modules/binary_caches.nix
        inputs.hm.nixosModule
        {
          home-manager = {
            useGlobalPkgs = true;
            extraSpecialArgs = { inherit inputs; };
          };
        }
      ];

      outputsBuilder = channels:
        let
          pkgs = channels.nixpkgs;
        in
        {
          devShells.nvim-config = import ./home/neovim/dev-shell.nix pkgs;
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

    # neovim plugins
    neovim-mapx = {
      url = "github:b0o/mapx.nvim";
      flake = false;
    };
    neovim-session-lens = {
      url = "github:rmagatti/session-lens";
      flake = false;
    };
    neovim-lspsaga-nvim = {
      # Use tami5's fork
      url = "github:tami5/lspsaga.nvim";
      flake = false;
    };
    neovim-coq-nvim = {
      url = "github:ms-jpq/coq_nvim";
      flake = false;
    };
    neovim-autosave = {
      url = "github:Pocco81/AutoSave.nvim";
      flake = false;
    };
    neovim-tabout = {
      url = "github:abecodes/tabout.nvim";
      flake = false;
    };
    neovim-neoclip = {
      url = "github:AckslD/nvim-neoclip.lua";
      flake = false;
    };
    neovim-lua-dev = {
      url = "github:folke/lua-dev.nvim";
      flake = false;
    };
    neovim-bufdelete-nvim = {
      url = "github:famiu/bufdelete.nvim";
      flake = false;
    };
    neovim-trouble-nvim = {
      url = "github:yelite/trouble.nvim";
      flake = false;
    };
    neovim-neorg = {
      url = "github:nvim-neorg/neorg";
      flake = false;
    };
    neovim-neorg-telescope = {
      url = "github:nvim-neorg/neorg-telescope";
      flake = false;
    };
    neovim-neorg-trouble = {
      url = "github:quantum-booty/neorg-trouble";
      flake = false;
    };
    neovim-hop-extensions = {
      url = "github:IndianBoy42/hop-extensions";
      flake = false;
    };
    neovim-telescope-file-browser = {
      url = "github:nvim-telescope/telescope-file-browser.nvim";
      flake = false;
    };
  };
}
