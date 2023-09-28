{
  fetchzip,
  fetchurl,
  runCommandLocal,
  zstd,
  ...
}: let
  zhwiki-20230823 = fetchurl {
    url = "https://github.com/felixonmars/fcitx5-pinyin-zhwiki/releases/download/0.2.4/zhwiki-20230823.dict.yaml";
    hash = "sha256-2cx+enR+2lK0o+pYoP8CQg3qd2+nBpQVZhDj4pEPQjU=";
  };
  moegirl-20230823 = fetchzip {
    url = "https://github.com/outloudvi/mw2fcitx/releases/download/20230814/fcitx5-pinyin-moegirl-rime-20230814-1-any.pkg.tar.zst";
    hash = "sha256-2fOU9aiXyFwegz4VrRBhnwvVasEXCuyGC/CEFw3/JYI=";
    nativeBuildInputs = [zstd];
    stripRoot = false;
  };
in
  runCommandLocal "fcitx5-rime-zh-dict" {} ''
    mkdir -p $out/share/rime-data
    cp -r ${zhwiki-20230823} $out/share/rime-data/zhwiki.dict.yaml
    cp -r ${moegirl-20230823}/usr/share/rime-data/moegirl.dict.yaml $out/share/rime-data/
  ''
