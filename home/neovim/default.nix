{
  config,
  pkgs,
  lib,
  hostPlatform,
  ...
}:
with lib; let
  cfg = config.myHomeConfig.neovim;
  sqlite3_lib_path =
    if pkgs.stdenv.isLinux
    then "${pkgs.sqlite.out}/lib/libsqlite3.so"
    else if pkgs.stdenv.isDarwin
    then "${pkgs.sqlite.out}/lib/libsqlite3.dylib"
    else assert false; "Unsupported";
  my-treesitter = pkgs.vimPlugins.nvim-treesitter.withPlugins (p:
    with p; [
      astro
      c
      cpp
      cmake
      rust
      python
      html
      css
      javascript
      bash
      fish
      go
      json
      jsonc
      lua
      nix
      norg
      markdown
      (markdown_inline.overrideAttrs (old: {
        EXTENSION_WIKI_LINK = true;
        nativeBuildInputs = old.nativeBuildInputs ++ [pkgs.nodejs pkgs.tree-sitter];
        configurePhase =
          old.configurePhase
          + ''
            tree-sitter generate
          '';
      }))
      prisma
      query
      sql
      tsx
      typescript
      toml
      yaml
      yuck
      vim
    ]);
in {
  options = {
    myHomeConfig.neovim = {
      enable = mkEnableOption "neovim";
    };
  };

  config = mkIf cfg.enable {
    home.packages = lib.optionals hostPlatform.isLinux [
      pkgs.neovide
    ];

    home.sessionVariables = {
      EDITOR = "nvim";
    };

    programs.neovim = {
      enable = true;

      plugins = with pkgs.vimPlugins; [
        plenary-nvim
        popup-nvim

        my-treesitter
        nvim-treesitter-textobjects
        nvim-treesitter-refactor
        playground # treesitter-playground

        nord-nvim
        nvim-web-devicons
        hologram-nvim
        nui-nvim
        pets-nvim
        dressing-nvim
        indent-blankline-nvim
        gitsigns-nvim
        bufdelete-nvim
        gitlinker-nvim

        leap-nvim
        flash-nvim
        hop-nvim
        hop-extensions
        nvim-autopairs
        vim-repeat
        vim-surround
        vim-subversive
        vim-textobj-entire
        nvim-spectre
        bullets-vim

        lualine-nvim
        nvim-navic
        telescope-nvim
        telescope-fzf-native-nvim
        telescope-file-browser-nvim
        telescope-live-grep-args-nvim
        telescope-alternate
        nvim-termfinder
        toggleterm-nvim
        which-key-nvim
        legendary-nvim

        autosave
        possession-nvim
        nvim-neoclip-lua

        zen-mode-nvim
        glow-nvim
        obsidian-nvim

        nvim-lspconfig
        nvim-lsp-basic
        fidget-nvim
        lspsaga-nvim
        nvim-code-action-menu
        goto-preview
        glance-nvim
        nvim-navbuddy
        trouble-nvim
        aerial-nvim
        nvim-dap
        nvim-cmp
        cmp-buffer
        cmp-nvim-lsp
        cmp-path
        cmp-cmdline
        cmp_luasnip
        luasnip
        lspkind-nvim
        lsp_signature-nvim

        todo-comments-nvim
        comment-nvim
        null-ls-nvim
        neodev-nvim
        rust-tools-nvim
        clangd_extensions-nvim
        go-nvim
        SchemaStore-nvim

        {
          plugin = sqlite-lua;
          config = "let g:sqlite_clib_path = '${sqlite3_lib_path}'";
        }
      ];

      extraConfig = ''
        lua << END🤞
          vim.g._my_config_script_folder = "${./scripts}"
          vim.g._friendly_snippets_path = "${pkgs.vimPlugins.friendly-snippets}"
          require "my-config"
        END🤞
      '';

      extraPackages = with pkgs;
        [
          # for treesitter
          gcc
          fd
          ripgrep
          stylua
          graphviz # For rust crate graph visualization
          sqlite # For sqlite.lua

          glow

          clang-tools
          rust-analyzer
          rustfmt

          gopls
          golines
          gofumpt
          golangci-lint
          impl
          reftools
          delve
          gomodifytags

          nil
          alejandra
          taplo
          sumneko-lua-language-server
          cmake-language-server
          python3Packages.jedi-language-server
          marksman

          nodePackages.prettier
          nodePackages.yaml-language-server
          nodePackages.vscode-langservers-extracted
          vtsls
          nodePackages."@astrojs/language-server"
          nodePackages."@tailwindcss/language-server"
        ]
        ++ lib.optionals hostPlatform.isDarwin [
          pngpaste # For ObsidianPasteImg
        ];

      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      withPython3 = true;
      withRuby = false;
    };

    xdg.configFile."nvim/lua".source = ./lua;
  };
}
