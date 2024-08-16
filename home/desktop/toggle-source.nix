{
  config,
  pkgs,
  lib,
  ...
}: let
  primaryMonitor = config.myConfig.desktop.monitors.primary;
  secondaryMonitor = config.myConfig.desktop.monitors.secondary;
in
  lib.mkIf config.myConfig.desktop.enable {
    home.packages = with pkgs; [
      ddcutil
      (writeShellScriptBin "toggle-display-source" ''
        export PRIMARY_MONITOR_DISPLAY_NUM=${primaryMonitor.id};
        export PRIMARY_MONITOR_LOCAL_INPUT_SOURCE=${primaryMonitor.localSource};
        export PRIMARY_MONITOR_REMOTE_INPUT_SOURCE=${primaryMonitor.remoteSource};
        export SECONDARY_MONITOR_DISPLAY_NUM=${secondaryMonitor.id};
        export SECONDARY_MONITOR_LOCAL_INPUT_SOURCE=${secondaryMonitor.localSource};
        export SECONDARY_MONITOR_REMOTE_INPUT_SOURCE=${secondaryMonitor.remoteSource};
        bash ${./toggle-source.sh} $@
      '')
    ];
  }
