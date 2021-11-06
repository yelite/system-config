{ pkgs, inputs, ... }:
let
  extraVimPlugins = (import ./plugins.nix) pkgs;
in
{
  imports = [
  ];

  home.packages = with pkgs; [
    fd
    ripgrep
  ];

  programs.neovim = {
    enable = true;

    plugins = with pkgs.vimPlugins; [
      nord-nvim
      nvim-web-devicons

      lualine-nvim
      nvim-gps

      nvim-treesitter
      nvim-treesitter-textobjects
      nvim-treesitter-refactor

      auto-session
      extraVimPlugins.session-lens

      telescope-nvim
      telescope-fzf-native-nvim

      which-key-nvim
      extraVimPlugins.mapx

      vim-nix

      extraVimPlugins.stabilize
    ];

    extraConfig = ''
      lua << END🤞
        
        require "my-config.basic"
        require "my-config.keymap"
        require "my-config.treesitter"
        require "my-config.statusline"
        require "my-config.colors"

      END🤞
      '';

    # for treesitter
    extraPackages = [ pkgs.gcc ];

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withPython3 = false;
    withRuby = false;
  };

  xdg.configFile."nvim/lua/my-config".source = ./my-config;
  
}
