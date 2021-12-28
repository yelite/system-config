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

  sddm-breeze514 = stdenv.mkDerivation rec {
    pname = "sddm-breeze514";
    version = "75d5be785afb5059d46999b8973c77f6a401ddd6";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src $out/share/sddm/themes/breeze514
    '';
    src = fetchFromGitHub {
      owner = "flipwise";
      repo = "sddm-breeze-514";
      rev = "${version}";
      sha256 = "EIwi75L8zD0/PXDQp0i8kTUtejb2kk0cCMn701sws+o=";
    };
  };
}
