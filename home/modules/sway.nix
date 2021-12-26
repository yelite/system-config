{ config, lib, pkgs, ... }:
{
  wayland.windowManager.sway = {
    enable = true;
    systemdIntegration = true;

    extraOptions = [
      "--unsupported-gpu"
    ];

    extraSessionCommands = ''
      export MOZ_ENABLE_WAYLAND=1
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export SDL_VIDEODRIVER=wayland
      export XDG_CURRENT_DESKTOP="sway"
      export XDG_SESSION_TYPE="wayland"
      export _JAVA_AWT_WM_NONREPARENTING=1
      export GBM_BACKEND=nvidia-drm
      export GBM_BACKENDS_PATH=/run/opengl-driver/lib/gbm
      export OCL_ICD_VENDORS=/run/opengl-driver/etc/OpenCL/vendors
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export WLR_NO_HARDWARE_CURSORS=1
    '';
    wrapperFeatures = { gtk = true; };


    # config = removeAttrs  config.xsession.windowManager.i3.config ["startup"];
    config = {
      terminal = "${pkgs.kitty}/bin/kitty";


      focus.forceWrapping = lib.mkForce true;
      startup = [
        { command = "wl-paste -t text --watch clipman store"; }
        { command = ''wl-paste -p -t text --watch clipman store -P --histpath="~/.local/share/clipman-primary.json"''; }
        { command = "mkfifo $SWAYSOCK.wob && tail -f $SWAYSOCK.wob | wob"; }
      ];
    };

    # https://github.com/dylanaraps/pywal/blob/master/pywal/templates/colors-sway
    extraConfig = ''
      smart_gaps yes
    '';
  };

  home.packages = with pkgs; [
    # grimshot # simplifies usage of grim ?
    clipman # clipboard manager, works with wofi
    foot # terminal
    grim # replace scrot
    kanshi # autorandr-like
    wofi # rofi-like
    slurp # capture tool
    # wf-recorder # for screencasts
    # bemenu as a dmenu replacement
    waybar # just for testing
    wl-clipboard # wl-copy / wl-paste
    wdisplays # to show 
    wob # to display a progressbar
  ];

  programs.mako = {
    enable = true;
    defaultTimeout = 4000;
    ignoreTimeout = false;
  };

  services.kanshi = {
    enable = true;
    # profiles = 
    # extraConfig = 
  };
}
