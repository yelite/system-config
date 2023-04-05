{ pkgs, ... }:
pkgs.mkShell {
  name = "nvim-config-dev-shell";
  /*
    Add the path to the lua module in the repo (different than the path in nix store)
    to vim runtimepath to make it faster to tweak neovim config, as we no longer need 
    to rebuild the flake and system before testing changes in neovim lua config.

    The dev-shell.fish is to update the prompt to ditinguish the dev shell from normal ones.
  */
  shellHook = ''
    export VIMINIT='set rtp^=~/.system-config/modules/programs/neovim/ | source ~/.config/nvim/init.lua'

    exec fish --init-command='source ${./dev-shell.fish}'
  '';
}
