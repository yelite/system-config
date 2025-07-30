final: prev:
{
  apple-cursor = final.callPackage ./apple-cursor.nix {};
  i3-focus-last = final.callPackage ./i3-focus-last.nix {};
  fcitx5-fluent-dark = final.callPackage ./fcitx5-fluent-dark {};
  rime-dict = final.callPackage ./rime-dict.nix {};
  flake-repl = final.callPackage ./flake-repl {};
  dcd = final.callPackage ./dcd.nix {};

  flameshot = prev.flameshot.overrideAttrs (old: {
    patches = old.patches ++ [./patches/flameshot.patch];
  });

  supersonic =
    if prev.stdenv.isDarwin
    then
      prev.supersonic.overrideAttrs (old: {
        postPhases = (old.postPhases or []) ++ ["patchMacOSBundleIconPhase"];
        patchMacOSBundleIconPhase = let
          iconFile = prev.fetchurl {
            url = "https://raw.githubusercontent.com/yelite/supersonic/fix-macos-icon/res/appicon-macos.icns";
            sha256 = "sha256-WKIF1jfk4xVHV7p19nKUJJu6qohmHvWOKSy0YxY+5vE=";
          };
        in ''
          cp ${iconFile} $out/Applications/Supersonic.app/Contents/Resources/supersonic.icns
        '';
      })
    else
      prev.supersonic.overrideAttrs (old: {
        nativeBuildInputs = (old.nativeBuildInputs or []) ++ [prev.makeWrapper];
        postInstall =
          (old.postInstall or "")
          + ''
            wrapProgram $out/bin/supersonic \
              --set FYNE_SCALE 2
          '';
      });
}
// prev.lib.optionalAttrs prev.stdenv.isDarwin {
  hammerspoon = final.callPackage ./hammerspoon.nix {};
  firefox-devedition-bin = final.callPackage ./firefox-devedition-darwin.nix {};
}
