{ pkgs, inputs, ... }:
let
  extraPlugins = (import ./plugins.nix) pkgs;
in
{
  imports = [
  ];

  home.packages = with pkgs; [
    fd
    ripgrep
    stylua
  ];

  programs.neovim = {
    enable = true;

    plugins = with pkgs.vimPlugins; [
      nord-nvim
      nvim-web-devicons

      extraPlugins.autosave
      auto-pairs
      vim-repeat
      vim-surround

      lualine-nvim
      nvim-gps

      nvim-treesitter
      nvim-treesitter-textobjects
      nvim-treesitter-refactor

      auto-session
      extraPlugins.session-lens

      telescope-nvim
      telescope-fzf-native-nvim
      toggleterm-nvim

      which-key-nvim
      extraPlugins.mapx

      gitsigns-nvim

      neoformat
      vim-nix

      extraPlugins.stabilize
    ];

    extraConfig = ''
      lua << END🤞
        
        require "my-config.basic"
        require "my-config.keymap"
        require "my-config.terminal"
        require "my-config.treesitter"
        require "my-config.languages"
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
