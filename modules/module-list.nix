let
  inherit (import ./util.nix) hybridModule hybridModules homeManagerModule homeManagerModules;
in
[
  (hybridModules [
    ./basic
    ./gui
  ])
  ./binary-caches.nix
  ./home-manager-adapter.nix
  ./uinput.nix
  ./xserver
  ./keyboard-remap
  ./logitech
  ./nvfancontrol
  # TODO: think about how to integrate overlay into hybrid module system
  # ./sway-nvidia

  (homeManagerModules [
    ./programs/neovim
    ./programs/i3
    ./programs/kitty
    ./programs/sway.nix
  ])
]
