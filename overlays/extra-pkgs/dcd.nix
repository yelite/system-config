{
  stdenv,
  fetchgit,
  git,
  dmd,
}:
stdenv.mkDerivation rec {
  pname = "dcd";
  version = "0.15.2";

  src = fetchgit {
    url = "https://github.com/dlang-community/DCD";
    rev = "v${version}";
    sha256 = "4gZXHLCkfB5wqhxUWwJekY1oW7CY4qaskaXYidnGR2Y=";
    fetchSubmodules = true;
    leaveDotGit = true;
    deepClone = true;
  };

  buildInputs = [
    git
    dmd
  ];

  installPhase = ''
    install -d $out/bin
    install -m 755 bin/dcd-client $out/bin/dcd-client
    install -m 755 bin/dcd-server $out/bin/dcd-server
  '';
}
