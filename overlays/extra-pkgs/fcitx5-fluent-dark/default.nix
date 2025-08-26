{
  stdenv,
  fetchzip,
  ...
}:
stdenv.mkDerivation {
  pname = "fcitx5-fluent-dark";
  version = "0.4.0";
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/share/fcitx5/themes/FluentDark-solid
    cp -r $src/FluentDark-solid/*.png $out/share/fcitx5/themes/FluentDark-solid/
    cp ${./theme.conf} $out/share/fcitx5/themes/FluentDark-solid/theme.conf
  '';
  src = fetchzip {
    url = "https://github.com/Reverier-Xu/FluentDark-fcitx5/archive/refs/tags/v0.4.0.tar.gz";
    sha256 = "sha256-wefleY3dMM3rk1/cZn36n2WWLuRF9dTi3aeDDNiR6NU=";
  };
}
