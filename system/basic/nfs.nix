{pkgs, ...}: {
  # TODO: Add option for this
  boot.supportedFilesystems = ["nfs"];
  environment.systemPackages = with pkgs; [
    nfs-utils
  ];
  services.rpcbind.enable = true;
}
