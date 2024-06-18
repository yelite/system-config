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
    telescope-alternate = {
      url = "github:otavioschwanck/telescope-alternate";
      flake = false;
    };
    possession-nvim = {
      url = "github:jedrzejboczar/possession.nvim";
      flake = false;
    };
    gitlinker-nvim = {
      url = "github:linrongbin16/gitlinker.nvim";
      flake = false;
    };
    pets-nvim = {
      url = "github:giusgad/pets.nvim";
      flake = false;
    };
    lazydev-nvim = {
      url = "github:folke/lazydev.nvim";
      flake = false;
    };
    smart-open-nvim = {
      url = "github:danielfalk/smart-open.nvim";
      flake = false;
    };
    hlchunk-nvim = {
      url = "github:shellRaining/hlchunk.nvim";
      flake = false;
    };
  };
}
