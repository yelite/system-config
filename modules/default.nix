let
  systemModules = [
    ./basic
    ./binary-caches.nix
    ./home-manager

    # NixOS only
    ./uinput.nix
    ./display
    ./keyboard-remap
    ./logitech
    ./nvfancontrol
  ];
in
systemModules
