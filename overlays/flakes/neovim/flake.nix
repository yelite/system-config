{
  description = "Extra plugins for neovim";

  outputs = {...} @ inputs: {
    overlay = let
      pluginInputs = builtins.removeAttrs inputs ["nixpkgs"];
    in (final: prev: {
      vimPlugins =
        prev.vimPlugins
        // (import ./build-plugins.nix) prev pluginInputs;
    });
  };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    autosave = {
      url = "github:Pocco81/AutoSave.nvim";
      flake = false;
    };
    hop-extensions = {
      url = "github:IndianBoy42/hop-extensions";
      flake = false;
    };
    nvim-termfinder = {
      url = "github:tknightz/telescope-termfinder.nvim";
      flake = false;
    };
    nvim-lsp-basic = {
      url = "github:nanotee/nvim-lsp-basics";
      flake = false;
    };
    telescope-alternate = {
      url = "github:otavioschwanck/telescope-alternate";
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
    nord-nvim = {
      url = "github:gbprod/nord.nvim";
      flake = false;
    };
    nvim-navbuddy = {
      url = "github:SmiteshP/nvim-navbuddy";
      flake = false;
    };
  };
}
