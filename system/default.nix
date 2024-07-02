{
  lib,
  hostPlatform,
  ...
}: {
  imports =
    [
      ./nix.nix
      ./home-manager.nix
      ./options.nix
    ]
    ++ lib.optionals hostPlatform.isLinux [
      ./nixos.nix
      ./nfs.nix
      ./uinput.nix
      ./display
      ./keyboard-remap
      ./logitech
      ./nvfancontrol
    ]
    ++ lib.optionals hostPlatform.isDarwin [
      ./darwin.nix
    ];
}
