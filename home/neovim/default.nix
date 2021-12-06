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
      plenary-nvim
      popup-nvim

      nvim-treesitter
      nvim-treesitter-textobjects
      nvim-treesitter-refactor

      nord-nvim
      nvim-web-devicons
      indent-blankline-nvim
      gitsigns-nvim
      stabilize-nvim

      lightspeed-nvim
      tabout
      nvim-autopairs
      vim-repeat
      vim-surround
      vim-subversive

      lualine-nvim
      nvim-gps
      telescope-nvim
      telescope-fzf-native-nvim
      toggleterm-nvim
      which-key-nvim
      mapx

      autosave
      auto-session
      session-lens
      neoclip

      nvim-lspconfig
      lsp-status-nvim
      lspsaga-nvim
      vim-illuminate
      rust-tools-nvim
      nvim-dap
      coq-nvim
      comment-nvim
      neoformat
      vim-nix

      {
        plugin = sqlite-lua;
        config = "let g:sqlite_clib_path = '${pkgs.sqlite.out}/lib/libsqlite3.so'";
      }
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
      sqlite # For sqlite.lua
    ];

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withPython3 = true;
    withRuby = false;
  };

  xdg.configFile."nvim/lua/my-config".source = ./my-config;
}
