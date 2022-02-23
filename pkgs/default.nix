{ inputs }:

final: prev:
{
  apple-cursor = prev.callPackage ./apple-cursor.nix { };
  xremap = prev.callPackage ./xremap.nix { };

  cmake-language-server = prev.cmake-language-server.overrideAttrs (prevAttrs: {
    patches = prevAttrs.patches ++ [ ./cmake-language-server-dep-version.patch ];
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
