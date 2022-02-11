{ inputs }:

final: prev:
{
  apple-cursor = prev.callPackage ./apple-cursor.nix { };
  xremap = prev.callPackage ./xremap.nix { };

  cmake-language-server = prev.cmake-language-server.overrideAttrs (prevAttrs: {
    patches = prevAttrs.patches ++ [ ./cmake-language-server-dep-version.patch ];
  });

  # TODO: Remove after https://github.com/NixOS/nixpkgs/pull/159255 lands unstable
  python39 = prev.python39.override {
    packageOverrides = python-self: python-super: {
      furo = python-super.furo.overridePythonAttrs (oldAttrs: {
        format = "wheel";
        src = python-super.fetchPypi {
          inherit (oldAttrs) pname version;
          format = "wheel";
          dist = "py3";
          python = "py3";
          sha256 = "sha256-lYAWv+E4fB6N31udcWlracTqpc2K/JSSq/sAirotMAw=";
        };
        installCheckPhase = ''
          # furo was built incorrectly if this directory is empty
          # Ignore the hidden file .gitignore
          cd "$out/lib/python"*
          if [ "$(ls 'site-packages/furo/theme/furo/static/' | wc -l)" -le 0 ]; then
            echo 'static directory must not be empty'
            exit 1
          fi
          cd -
        '';
      });
    };
  };
}
