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
    url = "https://archive.mozilla.org/pub/devedition/releases/124.0b9/mac/en-US/Firefox%20124.0b9.dmg";
    sha256 = "sha256-69rXVKCZnYWdyUfRloA5/L8ZUwgEvA2O9D9ssZn/S/M=";
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
