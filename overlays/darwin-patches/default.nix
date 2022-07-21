let
  unbreakPyOpenssl = python: {
    pyopenssl = python.pyopenssl.overrideAttrs (old: {
      # Unbreak pyopenssl
      # https://github.com/NixOS/nixpkgs/pull/172397,
      # https://github.com/pyca/pyopenssl/issues/87
      meta = old.meta // { broken = false; };
    });
  };
in
final: prev:
{
  cmake-language-server = prev.cmake-language-server.overrideAttrs (prevAttrs: {
    patches = prevAttrs.patches ++ [ ./cmake-language-server-dep-version.patch ];
  });

  kitty = prev.kitty.overridePythonAttrs (prevAttrs: {
    # Remove fish from checkInputs to skip a failed test
    checkInputs = builtins.filter (d: d.pname or "" != "fish") prevAttrs.checkInputs;
  });

  python39 = prev.python39.override {
    packageOverrides = python-self: python-super:
      { } // unbreakPyOpenssl python-super;
  };

  python310 = prev.python310.override {
    packageOverrides = python-self: python-super:
      {
        fonttools = python-super.fonttools.overridePythonAttrs
          (old: {
            checkInputs = builtins.filter (d: builtins.isNull (builtins.match ".*-pathops-.*" d.name)) old.checkInputs;
          });
        # Skip the tornado dependency due to pyopenssl issue
        matplotlib = python-super.matplotlib.overridePythonAttrs
          (old: {
            propagatedBuildInputs = builtins.filter (d: builtins.isNull (builtins.match ".*-tornado-.*" d.name)) old.propagatedBuildInputs;
          });
      } // unbreakPyOpenssl python-super
    ;
  };
}
