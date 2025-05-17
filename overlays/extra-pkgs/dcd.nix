{
  stdenv,
  fetchgit,
  lib,
  git,
  dmd,
  ldc,
}:
stdenv.mkDerivation rec {
  pname = "dcd";
  version = "0.15.2";

  src = fetchgit {
    url = "https://github.com/dlang-community/DCD";
    rev = "v${version}";
    sha256 =
      if stdenv.isLinux
      then "4gZXHLCkfB5wqhxUWwJekY1oW7CY4qaskaXYidnGR2Y="
      # TODO: investigate why this differs
      else "lF0ABgshjzICa+QUeSxO3XPezXSWWMIZmKzp/nrxxUU=";
    fetchSubmodules = true;
    leaveDotGit = true;
    deepClone = true;
  };

  buildInputs =
    [
      git
    ]
    ++ lib.optional (stdenv.isDarwin) [
      ldc
    ]
    ++ lib.optional (stdenv.isLinux) [
      dmd
    ];

  buildPhase =
    if stdenv.isDarwin
    then ''
      make ldc
    ''
    else ''
      make all
    '';

  installPhase = ''
    install -d $out/bin
    install -m 755 bin/dcd-client $out/bin/dcd-client
    install -m 755 bin/dcd-server $out/bin/dcd-server
  '';

  meta = {broken = stdenv.isDarwin;};
}
