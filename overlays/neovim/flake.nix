{
  description = "Extra plugins for neovim";

  outputs = {...} @ inputs: {
    overlay = let
      pluginInputs = builtins.removeAttrs inputs ["nixpkgs"];
    in (final: prev: let
      extras = self: super: ((import ./build-plugins.nix) final.vimUtils.buildVimPlugin pluginInputs);
      overrides = self: super: {
        guihua = super.guihua.overrideAttrs (oldAttrs: {
          nvimRequireCheck = "guihua";
        });
        telescope-alternate = super.telescope-alternate.overrideAttrs (oldAttrs: {
          dependencies = [self.plenary-nvim self.telescope-nvim];
        });
        pets-nvim = super.pets-nvim.overrideAttrs (oldAttrs: {
          dependencies = [self.hologram-nvim self.nui-nvim];
          doCheck = false;
        });
        possession-nvim = super.possession-nvim.overrideAttrs (oldAttrs: {
          dependencies = [self.plenary-nvim self.telescope-nvim];
        });
        smart-open-nvim = super.smart-open-nvim.overrideAttrs (oldAttrs: {
          doCheck = false;
        });
        nvim-highlight-colors = super.nvim-highlight-colors.overrideAttrs {
          # Test module
          nvimSkipModules = [
            "nvim-highlight-colors.utils_spec"
            "nvim-highlight-colors.buffer_utils_spec"
            "nvim-highlight-colors.color.converters_spec"
            "nvim-highlight-colors.color.patterns_spec"
            "nvim-highlight-colors.color.utils_spec"
          ];
        };
        nvim-spectre = super.nvim-spectre.overrideAttrs (oldAttrs: {
          postInstall = "";
          doCheck = false;
        });
      };
    in {
      vimPlugins = (prev.vimPlugins.extend extras).extend overrides;
    });
  };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    autosave = {
      url = "github:Pocco81/AutoSave.nvim";
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
    nvim-lsp-endhints = {
      url = "github:chrisgrieser/nvim-lsp-endhints";
      flake = false;
    };
    guihua = {
      url = "github:ray-x/guihua.lua";
      flake = false;
    };
    nvim-highlight-colors = {
      url = "github:neckbeard-69/nvim-highlight-colors/e9eee7fa3d32eb2274f587571c361fae2c91f8bb";
      flake = false;
    };
  };
}
