{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.myConfig = {
    isServer = mkEnableOption "isServer";
  };
}
