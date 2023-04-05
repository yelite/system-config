let
  systemModules = [
    ./basic
    ./binary-caches.nix
    ./home-manager

    # NixOS only
    ./uinput.nix
    ./xserver
    ./keyboard-remap
    ./logitech
    ./nvfancontrol
    # TODO: reenable this after wayland on nvidia is stable
    # ./sway-nvidia
  ];
in
systemModules
