{
  pkgs,
  lib,
  hostPlatform,
  ...
}:
lib.mkMerge [
  {
    home.packages = with pkgs;
      [
        git-lfs
        git-filter-repo
        jq
        fx
        htop
        cloc

        ninja
        clang-tools

        golines
        gofumpt
        golangci-lint
        gotools
        reftools
        gomodifytags
        gotests
        iferr
        gotestsum
        govulncheck
        impl
        reftools
        delve
        gomodifytags

        vtsls

        deadnix
        nvd

        python3

        cloudflare-utils

        process-compose

        claude-code
        claude-code-notification
        ccmanager
        (pkgs.writeShellScriptBin "claude-direnv" ''
          if [[ -f .envrc ]]; then
            if ! ${pkgs.direnv}/bin/direnv status | grep -q "Found RC allowed 0"; then
              echo "Found .envrc in $(pwd)"
              read -p "Allow direnv for this directory? [y/N] " -n 1 -r
              echo
              if [[ $REPLY =~ ^[Yy]$ ]]; then
                ${pkgs.direnv}/bin/direnv allow
              else
                exit 1
              fi
            fi
            eval "$(${pkgs.direnv}/bin/direnv export bash)"
          fi
          exec ${pkgs.claude-code}/bin/claude "$@"
        '')
        # TODO: enable after the build failure is fixed.
        # gemini-cli
      ]
      ++ (with python3Packages; [
        ipython
        black
        pylint
        isort

        # Markdown preview
        # TODO: Enable this after it builds
        # grip
      ])
      ++ lib.optionals hostPlatform.isLinux [
        file
      ]
      ++ lib.optionals hostPlatform.isDarwin [
        (pkgs.writeShellScriptBin "gsed" "exec -a $0 ${gnused}/bin/sed $@")
      ];

    programs.go = {
      enable = true;
    };

    programs.git = {
      enable = true;
      lfs = {
        enable = true;
      };
    };

    xdg.configFile."process-compose/shortcuts.yaml".source =
      ./process-compose/shortcuts.yaml;

    xdg.configFile."ccmanager/config.json".text = builtins.toJSON {
      shortcuts = {
        returnToMenu = {
          ctrl = true;
          key = "s";
        };
        cancel = {
          key = "escape";
        };
      };
      worktree = {
        autoDirectory = true;
        copySessionData = true;
        sortByLastSession = true;
      };
      commandPresets = {
        presets = [
          {
            id = "1";
            name = "Claude";
            command = "claude";
          }
          {
            id = "2";
            name = "Claude with direnv";
            command = "claude-direnv";
          }
        ];
        defaultPresetId = "2";
      };
    };

    home.file.".claude/keybindings.json".text = builtins.toJSON {
      "$schema" = "https://www.schemastore.org/claude-code-keybindings.json";
      "$docs" = "https://code.claude.com/docs/en/keybindings";
      bindings = [
        {
          context = "Task";
          bindings = {
            "ctrl+b" = null;
          };
        }
      ];
    };

    home.file.".claude/settings.json".text = builtins.toJSON {
      env = {
        CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS = "1";
      };
      hooks = {
        Notification = [
          {
            matcher = "*";
            hooks = [
              {
                type = "command";
                command =
                  if hostPlatform.isDarwin
                  then "claude-code-notification --sound Ping"
                  else "claude-code-notification";
              }
            ];
          }
        ];
      };
    };
  }
  (lib.optionalAttrs hostPlatform.isDarwin {
    home.file."Library/Application Support/process-compose/shortcuts.yaml" = {
      source = ./process-compose/shortcuts.yaml;
    };
  })
]
