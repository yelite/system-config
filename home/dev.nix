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
        gemini-cli
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

    home.file.".claude/settings.json".text = builtins.toJSON {
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
