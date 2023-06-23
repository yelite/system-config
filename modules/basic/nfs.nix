{ pkgs, lib, hostPlatform, ... }:
lib.optionalAttrs hostPlatform.isLinux {
  boot.supportedFilesystems = [ "nfs" ];
  environment.systemPackages = with pkgs; [
    nfs-utils
  ];
  services.rpcbind.enable = true;
}
