{
  imports = [
    ../options.nix
    ./syncthing
    ./basic.nix
    ./dev.nix
    ./desktop
    ./neovim
    ./i3
    ./kitty
    ./neovim
    ./dunst
    ./fish
    ./firefox
    ./shpool.nix
    ./yazi
  ];

  config = {
    # https://github.com/nix-community/home-manager/issues/3047
    home.stateVersion = "23.11";
  };
}
