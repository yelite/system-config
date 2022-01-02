let
  util = import ./util.nix;
  hybridModules = import ./module-list.nix;
  moduleSplitResult = util.splitHybridModules hybridModules;
  homeModules = moduleSplitResult.homeModules;
in
{
  inherit homeModules;

  systemModules = moduleSplitResult.systemModules ++ [
    {
      myConfig.homeManagerModules = homeModules;
    }
  ];
}
