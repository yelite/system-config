{ pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.editor = false;
  boot.loader.systemd-boot.consoleMode = "max";
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "US/Eastern";
  time.hardwareClockInLocalTime = true;
  networking.timeServers = [ "pool.ntp.org" ];

  networking.hostName = "moonshot";
  networking.wireless.enable = false;
  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;

  myConfig = {
    display = {
      enable = true;
      highDPI = true;
      displayProfiles = import ./display-profiles.nix;
      xserver.enable = true;
      wayland.enable = true;
    };

    logitech.enable = true;
    keyboardRemap.enable = true;
    # TODO: Enable this after implementing the hysteresis
    nvfancontrol.enable = false;

    homeManagerConfig = {
      syncthing.enable = true;
      neovim.enable = true;
      kitty.enable = true;
      dunst.enable = true;
      fish.enable = true;
      i3 = {
        enable = true;
        secondaryMonitorName = "HDMI-0";
      };
    };
  };

  services.logind.extraConfig = ''
    HandlePowerKey=ignore
    HandleSuspendKey=lock
  '';

  services.xserver = {
    videoDrivers = [ "nvidia" ];
    screenSection = ''
      Option         "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
      Option         "AllowIndirectGLXProtocol" "off"
      Option         "TripleBuffer" "on"
    '';
    deviceSection = ''
      Option    "RegistryDwords" "RMUseSwI2c=0x01; RMI2cSpeed=100"
    '';
  };

  services.printing.enable = true;

  hardware = {
    cpu.amd.updateMicrocode = true;
    nvidia = {
      modesetting.enable = true;
    };
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        libva
        libvdpau-va-gl
      ];
    };
  };

  system.stateVersion = "21.05"; # Did you read the comment?

  systemd.services.disable-wakeup-from-GPP0 = {
    # Fix the system sleep issue (wake up immediately after sleep)
    description = "Disable ACPI wakeup from GPP0";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.bash}/bin/sh -c '${pkgs.coreutils}/bin/echo GPP0 > /proc/acpi/wakeup'";
      ExecStop = "${pkgs.bash}/bin/sh -c '${pkgs.coreutils}/bin/echo GPP0 > /proc/acpi/wakeup'";
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };
}
