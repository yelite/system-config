{ pkgs, inputs, ... }:
let
  extraPlugins = (import ./extract-extra-plugins.nix) pkgs inputs;
in
{
  imports = [
  ];

  programs.neovim = {
    enable = true;

    plugins = with pkgs.vimPlugins; with extraPlugins;[
      nord-nvim
      nvim-web-devicons
      indent-blankline-nvim

      plenary-nvim
      popup-nvim
      autosave
      nvim-autopairs
      vim-repeat
      vim-surround
      lightspeed-nvim
      comment-nvim

      lualine-nvim
      nvim-gps

      nvim-treesitter
      nvim-treesitter-textobjects
      nvim-treesitter-refactor

      auto-session
      session-lens

      telescope-nvim
      telescope-fzf-native-nvim
      toggleterm-nvim

      which-key-nvim
      mapx

      gitsigns-nvim

      neoformat
      vim-nix
      nvim-lspconfig
      lsp-status-nvim
      lspsaga-nvim
      rust-tools-nvim
      nvim-dap
      coq-nvim

      stabilize-nvim
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
    extraPackages = with pkgs; [
      gcc
      fd
      ripgrep
      stylua
      rust-analyzer
      rustfmt
      graphviz # For rust crate graph visualization
    ];

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withPython3 = true;
    withRuby = false;
  };

  xdg.configFile."nvim/lua/my-config".source = ./my-config;
}
