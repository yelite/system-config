let
  inherit (import ./module-list.nix)
    univeralSystemModules
    linuxOnlyModules
    darwinOnlyModules
    homeManagerModules;
  optionals = pred: list: if pred then list else [ ];
in
{
  getSystemModules = hostPlatform:
    univeralSystemModules ++
    optionals hostPlatform.isLinux linuxOnlyModules ++
    optionals hostPlatform.isDarwin darwinOnlyModules ++
    [
      {
        myConfig.homeManagerModules = homeManagerModules;
      }
    ];
}
