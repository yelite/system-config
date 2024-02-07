{
  config,
  lib,
  ...
}: let
  cfg = config.myConfig.uinput;
  inherit (lib) mkIf mkEnableOption;
in {
  options = {
    myConfig.uinput.enableGroup = mkEnableOption "keyboardRemap";
  };

  config =
    mkIf cfg.enableGroup
    {
      users.groups.uinput = {};
      services.udev.extraRules = ''
        KERNEL=="uinput", GROUP="uinput", MODE:="0660", OPTIONS+="static_node=uinput"
      '';
    };
}
