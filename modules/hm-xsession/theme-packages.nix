{ stdenv, fetchFromGitHub }:
{
  sddm-slice = stdenv.mkDerivation rec {
    pname = "sddm-slice-theme";
    version = "1.5.1";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src $out/share/sddm/themes/slice
    '';
    src = fetchFromGitHub {
      owner = "RadRussianRus";
      repo = "sddm-slice";
      rev = "${version}";
      sha256 = "1AxRM2kHOzqjogYjFXqM2Zm8G3aUiRsdPDCYTxxQTyw=";
    };
  };
}
