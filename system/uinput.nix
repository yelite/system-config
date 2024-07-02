{
  config,
  lib,
  ...
}:
lib.mkIf config.myConfig.uinputGroup.enable
{
  users.groups.uinput = {};
  # Allow group uinput to access /dev/uinput, so that users can emulate input devices
  services.udev.extraRules = ''
    KERNEL=="uinput", GROUP="uinput", MODE:="0660", OPTIONS+="static_node=uinput"
  '';
}
