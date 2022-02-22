let
  inherit (import ./module-list.nix)
    univeralSystemModules
    linuxOnlyModules
    darwinOnlyModules
    homeManagerModules;
  optionals = pred: list: if pred then list else [ ];
in
{
  getSystemModules = systemInfo:
    univeralSystemModules ++
    optionals systemInfo.isLinux linuxOnlyModules ++
    optionals systemInfo.isDarwin darwinOnlyModules ++
    [
      {
        myConfig.homeManagerModules = homeManagerModules;
      }
    ];
}
