{ inputs }:

final: prev:
{
  apple-cursor = prev.callPackage ./apple-cursor.nix { };
  xremap = prev.callPackage ./xremap.nix { };

  cmake-language-server = prev.cmake-language-server.overrideAttrs (prevAttrs: {
    patches = prevAttrs.patches ++ [ ./cmake-language-server-dep-version.patch ];
  });

  vivaldi-widevine = prev.vivaldi-widevine.overrideAttrs (prevAttrs: {
    src = prev.fetchurl {
      url = "https://dl.google.com/widevine-cdm/${prevAttrs.version}-linux-x64.zip";
      sha256 = "sha256-vsr6eymKqU2Y6HM4DPHnUfVkB2BQ1HSSWvk1tNhUA5Y=";
    };
  });

  kitty = prev.kitty.overrideAttrs (prevAttrs: {
    patches = prevAttrs.patches ++ prev.lib.optionals prev.stdenv.isDarwin [
      (prev.fetchpatch {
        name = "fix-build-with-non-framework-python-on-darwin.patch";
        url = "https://github.com/kovidgoyal/kitty/commit/57cffc71b78244e6a9d49f4c9af24d1a88dbf537.patch";
        sha256 = "sha256-1IGONSVCVo5SmLKw90eqxaI5Mwc764O1ur+aMsc7h94=";
      })
    ];
  });
  python39 = prev.python39.override {
    packageOverrides = python-self: python-super:
      let
        inherit (prev.lib) optionalString optionals;
        inherit (prev.stdenv) isDarwin;
      in
      {
        # TODO: Remove after https://github.com/NixOS/nixpkgs/issues/160133 is fixed
        ipython = python-super.ipython.overridePythonAttrs (old: {
          preCheck = old.preCheck + optionalString isDarwin ''
            echo '#!${prev.stdenv.shell}' > pbcopy
            chmod a+x pbcopy
            cp pbcopy pbpaste
            export PATH="$(pwd)''${PATH:+":$PATH"}"
          '';
        });
        # TODO: Remove after https://github.com/NixOS/nixpkgs/issues/160904 is fixed
        uvloop = python-super.uvloop.overridePythonAttrs
          (old: {
            pytestFlagsArray = old.pytestFlagsArray ++ optionals isDarwin [
              "--deselect"
              "tests/test_context.py::Test_UV_Context::test_create_ssl_server_manual_connection_lost"
            ];
          });
      };
  };
}
