{
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.disko.nixosModules.disko
    ./hardware-configuration.nix
    ./disk.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.editor = false;
  boot.loader.systemd-boot.consoleMode = "max";
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "US/Eastern";
  time.hardwareClockInLocalTime = true;
  networking.timeServers = ["pool.ntp.org"];

  virtualisation.libvirtd.enable = true;

  users.users.${config.myConfig.username}.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMJlEkPKudGyqz5wue5k+kMOpVbxbv+A4jp2V/X+6Wtx"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOKv7WdB5E97No2NUWnF7RaqeqYy5csakTyvEgWq4DPA"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJZe8IqMw3y0S/jbEHa6FyqSFojG1HkngMBUkGd5jO+i"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID/q2cBM0nY7CLyPiyYxlpDITg3CWsDEIq2MrxnObNVn"
  ];

  myConfig = {
    isServer = true;

    display = {
      enable = false;
    };

    homeManagerConfig = {
      syncthing.enable = true;
      neovim.enable = true;
      fish.enable = true;
      kitty.enable = true;
    };
  };

  system.stateVersion = "24.05";
}
