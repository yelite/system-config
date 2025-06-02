# based on https://github.com/NixOS/nixpkgs/pull/194908
{
  lib,
  stdenv,
  fetchurl,
  undmg,
  ...
}: let
  version = "139.0b3";
  sha256 = "bb516b07c4519ae946b79a6fc34e911221e5d83851aab2bafdff87c3e5b74b3c";
in
  stdenv.mkDerivation {
    pname = "firefox-devedition-bin";
    inherit version;

    src = fetchurl {
      url = "https://archive.mozilla.org/pub/devedition/releases/${version}/mac/en-US/Firefox%20${version}.dmg";
      inherit sha256;
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
    };
  }
