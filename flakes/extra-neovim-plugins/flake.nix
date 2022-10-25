{
  description = "Extra plugins for neovim";

  outputs = { nixpkgs, ... }@inputs: {
    overlay =
      let
        pluginInputs = builtins.removeAttrs inputs [ "nixpkgs" ];
      in
      (final: prev: {
        vimPlugins = prev.vimPlugins //
          (import ./build-plugins.nix) prev pluginInputs;
      });
  };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    trouble-nvim = {
      url = "github:yelite/trouble.nvim";
      flake = false;
    };
    mapx = {
      url = "github:b0o/mapx.nvim";
      flake = false;
    };
    session-lens = {
      url = "github:rmagatti/session-lens";
      flake = false;
    };
    lspsaga-nvim = {
      url = "github:glepnir/lspsaga.nvim";
      flake = false;
    };
    autosave = {
      url = "github:Pocco81/AutoSave.nvim";
      flake = false;
    };
    tabout = {
      url = "github:abecodes/tabout.nvim";
      flake = false;
    };
    neorg = {
      url = "github:nvim-neorg/neorg";
      flake = false;
    };
    neorg-telescope = {
      url = "github:nvim-neorg/neorg-telescope";
      flake = false;
    };
    neorg-trouble = {
      url = "github:quantum-booty/neorg-trouble";
      flake = false;
    };
    hop-extensions = {
      url = "github:IndianBoy42/hop-extensions";
      flake = false;
    };
    harpoon = {
      url = "github:ThePrimeagen/harpoon";
      flake = false;
    };
    telescope-live-grep-args-nvim = {
      url = "github:nvim-telescope/telescope-live-grep-args.nvim";
      flake = false;
    };
    nvim-termfinder = {
      url = "github:tknightz/telescope-termfinder.nvim";
      flake = false;
    };
    incline-nvim = {
      url = "github:yelite/incline.nvim?ref=patch-1";
      flake = false;
    };
    toggleterm-nvim = {
      url = "github:akinsho/toggleterm.nvim";
      flake = false;
    };
    nvim-lsp-basic = {
      url = "github:nanotee/nvim-lsp-basics";
      flake = false;
    };
    nvim-treesitter = {
      url = "github:nvim-treesitter/nvim-treesitter";
      flake = false;
    };
    gitsigns-nvim = {
      url = "github:lewis6991/gitsigns.nvim";
      flake = false;
    };
  };
}
