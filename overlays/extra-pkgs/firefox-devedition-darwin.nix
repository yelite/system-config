# based on https://github.com/NixOS/nixpkgs/pull/194908
{
  lib,
  stdenv,
  fetchurl,
  undmg,
  ...
}: let
  version = "148.0b2";
  sha256 = "sha256-tH9sG+4VfWq2T9qsBOgJTnwg71QmE16XQiN9CCicPYw=";
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

    dontFixup = true;

    meta = with lib; {
      changelog = "https://www.mozilla.org/en-US/firefox/${version}/releasenotes/";
      description = "Mozilla Firefox, free web browser (binary package)";
      homepage = "https://www.mozilla.org/firefox/";
      license = licenses.mpl20;
      sourceProvenance = with sourceTypes; [binaryNativeCode];
      platforms = ["x86_64-darwin" "aarch64-darwin"];
    };
  }
