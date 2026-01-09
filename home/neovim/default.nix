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

    plugins = with pkgs.vimPlugins; [
      plenary-nvim
      popup-nvim

      {
        plugin = my-treesitter;
        config = ''vim.opt.rtp:prepend("${my-treesitter}/runtime/")'';
        type = "lua";
      }

      nvim-treesitter-textobjects

      gbprod-nord
      nvim-web-devicons
      pets-nvim
      hologram-nvim # dependency of pets-nvim
      nui-nvim # dependency of pets-nvim
      nvim-nio # dependency of nvim-dap-ui
      hlchunk-nvim
      gitsigns-nvim
      bufdelete-nvim
      gitlinker-nvim
      render-markdown-nvim

      leap-nvim
      flash-nvim
      hop-nvim
      hydra-nvim
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
      snacks-nvim

      autosave
      possession-nvim
      nvim-neoclip-lua

      zen-mode-nvim
      glow-nvim
      obsidian-nvim

      nvim-lspconfig
      fidget-nvim
      lspsaga-nvim
      nvim-highlight-colors
      trouble-nvim
      nvim-dap
      nvim-dap-ui
      nvim-dap-python
      blink-cmp
      lsp_signature-nvim
      nvim-lsp-endhints
      conform-nvim
      nvim-notify
      friendly-snippets

      todo-comments-nvim
      comment-nvim
      nvim-ts-context-commentstring
      lazydev-nvim
      rustaceanvim
      clangd_extensions-nvim
      go-nvim
      nvim-vtsls
      SchemaStore-nvim
      sqlite-lua
    ];

    extraConfig = ''
      lua << END🤞
      vim.g._my_config_script_folder = "${./scripts}"
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
        lua-language-server
        # TODO: re-enable this
        # cmake-language-server
        buf
        ruff
        basedpyright
        marksman
        biome

        nodePackages.nodejs
        nodePackages.prettier
        nodePackages.yaml-language-server
        nodePackages.vscode-langservers-extracted
        vtsls
        nodePackages."@astrojs/language-server"
        nodePackages."@tailwindcss/language-server"
        python3Packages.debugpy
      ]
      ++ lib.optionals hostPlatform.isLinux [
        # TODO: enable after build failure is fixed
        # serve-d
        # dcd
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
