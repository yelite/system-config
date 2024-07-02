{
  imports = [
    ../options.nix
    ./syncthing
    ./basic.nix
    ./dev.nix
    ./neovim
    ./i3
    ./kitty
    ./neovim
    ./dunst
    ./fish
    ./firefox
  ];

  config = {
    # https://github.com/nix-community/home-manager/issues/3047
    home.stateVersion = "23.11";
  };
}
