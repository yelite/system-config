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
      playground # treesitter-playground

      nord-nvim
      nvim-web-devicons
      indent-blankline-nvim
      gitsigns-nvim
      stabilize-nvim
      bufdelete-nvim

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

      neorg
      neorg-telescope
      neorg-trouble

      nvim-lspconfig
      lsp-status-nvim
      lspsaga-nvim
      trouble-nvim
      vim-illuminate
      nvim-dap
      coq-nvim
      todo-comments-nvim
      comment-nvim
      neoformat
      lua-dev
      rust-tools-nvim
      vim-nix

      {
        plugin = sqlite-lua;
        config = "let g:sqlite_clib_path = '${pkgs.sqlite.out}/lib/libsqlite3.so'";
      }
    ];

    extraConfig = ''
      lua << END🤞
        require "my-config"
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
      sumneko-lua-language-server
      graphviz # For rust crate graph visualization
      sqlite # For sqlite.lua
    ];

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withPython3 = true;
    withRuby = false;
  };

  xdg.configFile."nvim/lua".source = ./lua;
}
