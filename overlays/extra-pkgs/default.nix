final: prev:
{
  apple-cursor = prev.callPackage ./apple-cursor.nix { };
  xremap = prev.callPackage ./xremap.nix { };

  # rename the script of fup-repl from flake-utils-plus 
  my-fup-repl = final.fup-repl.overrideAttrs (old: {
    buildCommand = old.buildCommand + ''
      mv $out/bin/repl $out/bin/fup-repl
    '';
  });
}
