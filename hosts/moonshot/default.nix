{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.editor = false;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "US/Eastern";
  time.hardwareClockInLocalTime = true;

  networking.hostName = "moonshot";
  networking.wireless.enable = false;
  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;

  myConfig = {
    xserver = {
      enable = true;
      highDPI = true;
      displayProfiles = import ./display-profiles.nix;
    };

    logitech.enable = true;
    keyboardRemap.enable = true;
    # TODO: Enable this after implementing the hysteresis
    nvfancontrol.enable = false;

    homeManagerModules = [{
      myHomeConfig = {
        neovim.enable = true;
        kitty.enable = true;
        i3 = {
          enable = true;
          secondaryMonitorName = "HDMI-0";
        };
      };
    }];
  };

  services.xserver = {
    videoDrivers = [ "nvidia" ];
    screenSection = ''
      Option         "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
      Option         "AllowIndirectGLXProtocol" "off"
      Option         "TripleBuffer" "on"
    '';
  };

  services.printing.enable = true;

  hardware = {
    pulseaudio.enable = true;
    cpu.amd.updateMicrocode = true;
    nvidia = {
      modesetting.enable = true;
    };
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        libva
        vaapiVdpau
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
