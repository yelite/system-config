# based on https://github.com/NixOS/nixpkgs/pull/194908
{
  lib,
  stdenv,
  fetchurl,
  undmg,
}:
stdenv.mkDerivation {
  pname = "firefox-devedition-bin";
  version = "124.0b9";

  src = fetchurl {
    url = "https://archive.mozilla.org/pub/devedition/releases/128.0b4/mac/en-US/Firefox%20128.0b4.dmg";
    sha256 = "sha256-0V01Iv8jD0Do8/fFvQOABjnhXd6skf0Wdysovg8zASM=";
  };

  nativeBuildInputs = [undmg];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/Applications
    cp -r *.app $out/Applications
  '';

  meta = with lib; {
    changelog = "https://www.mozilla.org/en-US/firefox/${version}/releasenotes/";
    description = "Mozilla Firefox, free web browser (binary package)";
    homepage = "https://www.mozilla.org/firefox/";
    license = licenses.mpl20;
    sourceProvenance = with sourceTypes; [binaryNativeCode];
    platforms = ["x86_64-darwin" "aarch64-darwin"];
    hydraPlatforms = [];
    maintainers = with maintainers; [taku0 lovesegfault];
  };
}
