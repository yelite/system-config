final: prev:
{
  apple-cursor = final.callPackage ./apple-cursor.nix {};
  fcitx5-fluent-dark = final.callPackage ./fcitx5-fluent-dark {};
  rime-dict = final.callPackage ./rime-dict.nix {};
  flake-repl = final.callPackage ./flake-repl {};
  dcd = final.callPackage ./dcd.nix {};
  claude-code-notification = final.callPackage ./claude-code-notification.nix {};
  ccmanager = final.callPackage ./ccmanager {};

  flameshot = prev.flameshot.overrideAttrs (old: {
    patches = old.patches ++ [./patches/flameshot.patch];
  });

  claude-code = final.callPackage ./claude-code.nix {claude-code = prev.claude-code;};
}
// prev.lib.optionalAttrs prev.stdenv.isDarwin {
  hammerspoon = final.callPackage ./hammerspoon.nix {};
  firefox-devedition-bin = final.callPackage ./firefox-devedition-darwin.nix {};
}
