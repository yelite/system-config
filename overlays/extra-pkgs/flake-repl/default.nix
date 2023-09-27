# Inspired by https://github.com/gytis-ivaskevicius/flake-utils-plus/blob/master/lib/overlay.nix
{ writeShellScriptBin
, coreutils
, gnused
}:
let
  example = command: desc: ''\n\u001b[33m ${command}\u001b[0m - ${desc}'';
in
writeShellScriptBin "flake-repl" ''
  case "$1" in
    "-h"|"--help"|"help")
      printf "%b\n\e[4mUsage\e[0m: \
        ${example "repl" "Loads system flake if available."} \
        ${example "repl /path/to/flake.nix" "Loads specified flake."}\n"
    ;;
    *)
      if [ -z "$1" ]; then
        if [[ $OSTYPE == 'darwin'* ]]; then
          nix repl --argstr hostname $(hostname) ${./repl.nix}
        else
          nix repl ${./repl.nix}
        fi
      else
        nix repl --arg flakePath $(${coreutils}/bin/readlink -f $1 | ${gnused}/bin/sed 's|/flake.nix||') ${./repl.nix}
      fi
    ;;
  esac
''
