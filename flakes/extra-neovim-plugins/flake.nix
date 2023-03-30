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
    hop-extensions = {
      url = "github:IndianBoy42/hop-extensions";
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
    telescope-alternate = {
      url = "github:otavioschwanck/telescope-alternate";
      flake = false;
    };
    leap-nvim = {
      url = "github:ggandor/leap.nvim";
      flake = false;
    };
    flit-nvim = {
      url = "github:ggandor/flit.nvim";
      flake = false;
    };
    leap-spooky-nvim = {
      url = "github:ggandor/leap-spooky.nvim";
      flake = false;
    };
    possession-nvim = {
      url = "github:jedrzejboczar/possession.nvim";
      flake = false;
    };
    # Fork of gitlinker, making the user_opt.remote override branch remote
    # TODO: remove this fork after the change is upstreamed
    gitlinker-nvim = {
      url = "github:yelite/gitlinker.nvim";
      flake = false;
    };
    pets-nvim = {
      url = "github:giusgad/pets.nvim";
      flake = false;
    };
    hologram-nvim = {
      url = "github:edluffy/hologram.nvim";
      flake = false;
    };
    nui-nvim = {
      url = "github:MunifTanjim/nui.nvim";
      flake = false;
    };
    zk-nvim = {
      url = "github:mickael-menu/zk-nvim";
      flake = false;
    };
    zen-mode-nvim = {
      url = "github:folke/zen-mode.nvim";
      flake = false;
    };
    luasnip = {
      url = "github:L3MON4D3/LuaSnip";
      flake = false;
    };
    nvim-cmp = {
      url = "github:hrsh7th/nvim-cmp";
      flake = false;
    };
    cmp-buffer = {
      url = "github:hrsh7th/cmp-buffer";
      flake = false;
    };
    cmp-nvim-lsp = {
      url = "github:hrsh7th/cmp-nvim-lsp";
      flake = false;
    };
    cmp_luasnip = {
      url = "github:saadparwaiz1/cmp_luasnip";
      flake = false;
    };
    cmp-path = {
      url = "github:hrsh7th/cmp-path";
      flake = false;
    };
    cmp-cmdline = {
      url = "github:hrsh7th/cmp-cmdline";
      flake = false;
    };
    friendly-snippets = {
      url = "github:rafamadriz/friendly-snippets";
      flake = false;
    };

  };
}
