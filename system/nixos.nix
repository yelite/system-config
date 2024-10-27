{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config) myConfig;
in {
  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
    packages = with pkgs; [terminus_font];
    keyMap = "us";
  };

  environment.systemPackages = with pkgs; [
    git # used for nixos-rebuild
    killall
    cifs-utils
  ];

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "C.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
      "zh_CN.UTF-8/UTF-8"
    ];
  };

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
    };

    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };

  security = {
    sudo.enable = lib.mkDefault false;

    doas = {
      enable = true;
      extraRules = [
        {
          groups = ["wheel"];
          keepEnv = true;
          persist = true;
          noPass = false;
        }
      ];
    };
  };

  programs = {
    fish.enable = true;
    less.enable = true;
    ssh = {
      startAgent = true;
      enableAskPassword = false;
    };
  };

  environment.etc = {
    # Link the flake.nix so that nixos-rebuild works without extra arg
    "nixos/flake.nix" = {
      source = "/home/${myConfig.username}/.system-config/flake.nix";
    };
  };

  home-manager.users.root.programs.git = {
    enable = true;
    # Fix the git permission issue per https://github.com/NixOS/nixpkgs/issues/169193#issuecomment-1116090241
    extraConfig.safe.directory = "/home/${myConfig.username}/.system-config";
  };

  users.users.${myConfig.username} = {
    isNormalUser = true;
    shell = pkgs.fish;
    linger = true;
    # TODO: Split into different modules
    extraGroups = ["wheel" "networkmanager" "libvirtd" "i2c"];
  };
}
