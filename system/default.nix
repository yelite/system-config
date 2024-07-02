{
  lib,
  hostPlatform,
  ...
}: {
  imports =
    [
      ../options.nix
      ./nix.nix
      ./home-manager.nix
    ]
    ++ lib.optionals hostPlatform.isLinux [
      ./nixos.nix
      ./nfs.nix
      ./uinput.nix
      ./desktop
      ./nvfancontrol
    ]
    ++ lib.optionals hostPlatform.isDarwin [
      ./darwin.nix
    ];
}
