{ stdenv, fetchzip, ... }:
stdenv.mkDerivation rec {
  pname = "apple-cursor";
  version = "1.2.3";
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/share/icons
    cp -r $src $out/share/icons/macOSMonterey
  '';
  src = fetchzip {
    url = "https://github.com/ful1e5/apple_cursor/releases/download/v${version}/macOSMonterey.tar.gz";
    sha256 = "9tyLt81HreX+2XwEkGf3mt41tXG2ErTQ9ciw6lUPNyA=";
  };
}
