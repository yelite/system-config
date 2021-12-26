# This module is not in use because of the flickering issue as of 2021-12-23.
{ pkgs, ... }:
{
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
      libva
    ];
  };

  services.xserver = {
    videoDrivers = [ "nvidia" ];
    displayManager.sessionPackages = [
      (pkgs.writeTextFile
        {
          name = "sway";
          destination = "/share/wayland-sessions/sway.desktop";
          # Desktop Entry Specification:
          # - https://standards.freedesktop.org/desktop-entry-spec/latest/
          # - https://standards.freedesktop.org/desktop-entry-spec/latest/ar01s06.html
          text = ''
            [Desktop Entry]
            Type=Application
            Exec=sway
            Name=Sway
          '';
        } // {
        providedSessions = [ "sway" ];
      })
    ];
  };

  hardware.nvidia = {
    modesetting.enable = true;
  };

  environment.systemPackages = with pkgs; [
    qt5.qtwayland
  ];
}
