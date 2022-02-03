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
      # Use tami5's fork
      url = "github:tami5/lspsaga.nvim";
      flake = false;
    };
    coq-nvim = {
      url = "github:ms-jpq/coq_nvim";
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
  };
}
