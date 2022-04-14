{
  univeralSystemModules = [
    ./basic
    ./binary-caches.nix
    ./home-manager.nix
  ];
  linuxOnlyModules = [
    ./uinput.nix
    ./xserver
    ./keyboard-remap
    ./logitech
    ./nvfancontrol
    # TODO: reenable this after wayland on nvidia is stable
    # ./sway-nvidia
  ];
  darwinOnlyModules = [ ];
  homeManagerModules = [
    ./syncthing
    ./programs/basic.nix
    ./programs/dev.nix
    ./programs/neovim
    ./programs/i3
    ./programs/kitty
    ./programs/neovim
    ./programs/dunst
    ./programs/fish
    ./programs/sway.nix
  ];
}
