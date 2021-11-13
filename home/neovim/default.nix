{ pkgs, inputs, ... }:
let
  extraPlugins = (import ./plugins.nix) pkgs;
in
{
  imports = [
  ];

  programs.neovim = {
    enable = true;

    plugins =  with pkgs.vimPlugins; with extraPlugins;[
      nord-nvim
      nvim-web-devicons

      plenary-nvim
      popup-nvim
      autosave
      nvim-autopairs
      vim-repeat
      vim-surround
      lightspeed-nvim

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
      coq_nvim

      stabilize
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
