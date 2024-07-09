{...}: {
  perSystem = {pkgs, ...}: {
    devShells.default = pkgs.mkShell {
      name = "system-config-dev";
      packages = [
        (pkgs.writeShellScriptBin "nix-update" ''
          ${pkgs.nix-update}/bin/nix-update --flake $@
        '')
        (pkgs.writeShellScriptBin "nvim" ''
          export VIMINIT='set rtp^=$PWD/home/neovim/ | source $HOME/.config/nvim/init.lua'
          $HOME/.nix-profile/bin/nvim $@
        '')
        (pkgs.writeShellScriptBin "safe-nvim" ''
          $HOME/.nix-profile/bin/nvim $@
        '')
      ];
    };
  };
}
