{
  lib,
  hostPlatform,
  ...
}: {
  imports =
    [
      ./basic
      ./binary-caches.nix
      ./home-manager
    ]
    ++ lib.optionals hostPlatform.isLinux [
      ./uinput.nix
      ./display
      ./keyboard-remap
      ./logitech
      ./nvfancontrol
    ];
}
