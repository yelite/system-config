{
  config,
  pkgs,
  lib,
  hostPlatform,
  ...
}:
lib.mkIf config.myConfig.neovim.enable (let
  my-treesitter = pkgs.vimPlugins.nvim-treesitter.withPlugins (p:
    with p; [
      astro
      c
      cpp
      cmake
      d
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
      vimdoc
      yaml
      yuck
      vim
    ]);
in {
  home.packages =
    [
      (pkgs.writeShellScriptBin "nvim-dirty" ''
        export VIMINIT='set rtp^=${config.myConfig.publicConfigDirectory}/home/neovim/ | source $HOME/.config/nvim/init.lua'
        $HOME/.nix-profile/bin/nvim $@
      '')
    ]
    ++ lib.optionals hostPlatform.isLinux [
      # TODO: wait for https://github.com/NixOS/nixpkgs/pull/356292 to hit unstable
      # pkgs.neovide
    ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.neovim = {
    enable = true;

    plugins = with pkgs.vimPlugins;
      [
        plenary-nvim
        popup-nvim

        my-treesitter
        nvim-treesitter-textobjects

        gbprod-nord
        nvim-web-devicons
        pets-nvim
        hologram-nvim # dependency of pets-nvim
        nui-nvim # dependency of pets-nvim
        nvim-nio # dependency of nvim-dap-ui
        dressing-nvim
        hlchunk-nvim
        gitsigns-nvim
        bufdelete-nvim
        gitlinker-nvim
        render-markdown-nvim

        leap-nvim
        flash-nvim
        hop-nvim
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
        telescope-dap-nvim
        toggleterm-nvim
        which-key-nvim
        smart-open-nvim
        yazi-nvim
        guihua

        autosave
        possession-nvim
        nvim-neoclip-lua

        zen-mode-nvim
        glow-nvim
        obsidian-nvim

        nvim-lspconfig
        fidget-nvim
        lspsaga-nvim
        trouble-nvim
        nvim-dap
        nvim-dap-ui
        blink-cmp
        blink-cmp-avante
        blink-copilot
        lsp_signature-nvim
        nvim-lsp-endhints
        conform-nvim
        nvim-notify
        friendly-snippets

        todo-comments-nvim
        comment-nvim
        lazydev-nvim
        rustaceanvim
        clangd_extensions-nvim
        go-nvim
        SchemaStore-nvim
        sqlite-lua
      ]
      ++ lib.optionals config.myConfig.neovim.copilot.enable [
        copilot-lua
        copilot-lualine
        avante-nvim
      ];

    extraConfig = ''
      lua << END🤞
      vim.g._my_config_script_folder = "${./scripts}"
      vim.g._copilot_enabled = ${lib.boolToString config.myConfig.neovim.copilot.enable}
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
        buf
        python3Packages.jedi-language-server
        marksman

        nodePackages.nodejs
        nodePackages.prettier
        nodePackages.yaml-language-server
        nodePackages.vscode-langservers-extracted
        vtsls
        nodePackages."@astrojs/language-server"
        nodePackages."@tailwindcss/language-server"
      ]
      ++ lib.optionals hostPlatform.isLinux [
        serve-d
        dcd
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
})
