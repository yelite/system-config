{
  lib,
  hostPlatform,
  inputs,
  ...
}: {
  imports =
    [
      ../options.nix
      ./syncthing
      ./basic.nix
      ./dev.nix
      ./desktop
      ./neovim
      ./kitty
      ./neovim
      ./fish
      ./firefox
      ./shpool.nix
      ./yazi
      inputs.nix-index-database.homeModules.nix-index
    ]
    ++ lib.optionals hostPlatform.isLinux [
      ./dunst
      ./niri
    ]
    ++ lib.optionals hostPlatform.isDarwin [
      ./hammerspoon
    ];

  config = {
    # https://github.com/nix-community/home-manager/issues/3047
    home.stateVersion = "25.11";
    # We are on unstable for both nixpkgs and hm
    home.enableNixpkgsReleaseCheck = true;
  };
}
