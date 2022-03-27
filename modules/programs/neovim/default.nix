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

        lightspeed-nvim
        hop-nvim
        hop-extensions
        tabout
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
        telescope-rg-nvim
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
        lsp-status-nvim
        lspsaga-nvim
        trouble-nvim
        aerial-nvim
        vim-illuminate
        nvim-dap
        coq-nvim
        todo-comments-nvim
        comment-nvim
        neoformat
        lua-dev-nvim
        rust-tools-nvim
        clangd-extensions-nvim
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
        graphviz # For rust crate graph visualization
        sqlite # For sqlite.lua

        clang-tools

        rust-analyzer
        rustfmt

        # TODO: enable this after the lua side is finished
        # rnix-lsp
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
          python-lsp-server
          rope
          python-lsp-black
          pyls-isort
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
