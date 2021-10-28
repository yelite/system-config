{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "US/Eastern";
  time.hardwareClockInLocalTime = true;

  networking.hostName = "moonshot";
  networking.wireless.enable = false;
  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  services.printing.enable = true;

  sound.enable = true;

  hardware = {
    pulseaudio.enable = true;
    cpu.amd.updateMicrocode = true;
  };

  environment.systemPackages = with pkgs; [
    vivaldi
    vivaldi-widevine
    vivaldi-ffmpeg-codecs
    wget
    git
    standardnotes
    nixpkgs-fmt
  ];

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

