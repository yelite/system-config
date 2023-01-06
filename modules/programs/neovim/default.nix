{ config, pkgs, lib, inputs, systemInfo, ... }:
with lib;
let
  cfg = config.myHomeConfig.neovim;
in
{
  options = {
    myHomeConfig.neovim = {
      enable = mkEnableOption "neovim";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; lib.optionals systemInfo.isLinux [
      # TODO: Enable this for darwin after https://github.com/NixOS/nixpkgs/pull/146052 
      neovide
    ];

    home.sessionVariables = {
      EDITOR = "nvim";
    };

    programs.neovim = {
      enable = true;

      plugins = with pkgs.vimPlugins; [
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
        gitlinker-nvim

        leap-nvim
        flit-nvim
        leap-spooky-nvim
        hop-nvim
        hop-extensions
        nvim-autopairs
        vim-repeat
        vim-surround
        vim-subversive
        vim-textobj-entire
        nvim-spectre

        lualine-nvim
        nvim-gps
        telescope-nvim
        telescope-fzf-native-nvim
        telescope-file-browser-nvim
        telescope-live-grep-args-nvim
        telescope-alternate
        nvim-termfinder
        harpoon
        toggleterm-nvim
        which-key-nvim
        mapx

        autosave
        auto-session
        session-lens
        nvim-neoclip-lua

        neorg
        neorg-telescope
        neorg-trouble

        nvim-lspconfig
        nvim-lsp-basic
        lsp-status-nvim
        lspsaga-nvim
        nvim-code-action-menu
        goto-preview
        trouble-nvim
        aerial-nvim
        nvim-dap
        coq_nvim
        todo-comments-nvim
        comment-nvim
        null-ls-nvim
        neodev-nvim
        rust-tools-nvim
        clangd_extensions-nvim
        vim-nix

        {
          plugin = sqlite-lua;
          config = "let g:sqlite_clib_path = '${pkgs.sqlite.out}/lib/libsqlite3.so'";
        }
      ];

      extraConfig = ''
        lua << END🤞
          vim.g._my_config_script_folder = "${./scripts}"
          require "my-config"
        END🤞
      '';

      extraPackages = with pkgs; [
        # for treesitter
        gcc
        fd
        ripgrep
        stylua
        graphviz # For rust crate graph visualization
        sqlite # For sqlite.lua

        clang-tools

        rust-analyzer
        rustfmt

        rnix-lsp

        sumneko-lua-language-server
      ] ++
      (
        # TODO: fix the ssl error. 
        # Probably just need to point to the right certificate store when building
        lib.optional (!systemInfo.isDarwin)
          cmake-language-server
      ) ++ (
        with pkgs.python310Packages;
        [
          jedi-language-server
        ]
      );

      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      withPython3 = true;
      withRuby = false;
    };

    xdg.configFile."nvim/lua".source = ./lua;
  };
}
