{
  stdenv,
  fetchzip,
  ...
}:
stdenv.mkDerivation {
  pname = "fcitx5-fluent-dark";
  version = "0.3.0";
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/share/fcitx5/themes/FluentDark
    cp -r $src/FluentDark/*.png $out/share/fcitx5/themes/FluentDark/
    cp ${./theme.conf} $out/share/fcitx5/themes/FluentDark/theme.conf
  '';
  src = fetchzip {
    url = "https://github.com/Reverier-Xu/FluentDark-fcitx5/archive/refs/tags/v0.3.0.tar.gz";
    sha256 = "om3jI6XNpkmFBXarwROKb6ldvCKaKzrBkLAdPmCxWkU=";
  };
}
