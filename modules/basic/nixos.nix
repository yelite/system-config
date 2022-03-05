{ config, pkgs, lib, systemInfo, ... }:
let myConfig = config.myConfig;
in
lib.optionalAttrs systemInfo.isLinux {
  nix = {
    autoOptimiseStore = true;

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    # FUP options
    generateNixPathFromInputs = true;
    generateRegistryFromInputs = true;
    linkInputs = true;
  };

  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
    packages = with pkgs; [ terminus_font ];
    keyMap = "us";
  };

  environment.systemPackages = with pkgs; [
    killall
    cifs-utils
  ];

  networking.networkmanager.enable = true;

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "zh_CN.UTF-8/UTF-8"
    ];
  };

  services = {
    avahi = {
      enable = true;
      nssmdns = true;
      publish.enable = false;
    };

    openssh = {
      enable = true;
      useDns = true;
    };

    # Hide the cursor when typing.
    xbanish.enable = true;
  };

  security = {
    rtkit.enable = true;
    sudo.enable = false;

    doas = {
      enable = true;
      extraRules = [
        {
          groups = [ "wheel" ];
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
  };

  environment.etc = {
    # Link the flake.nix so that nixos-rebuild works without extra arg
    "nixos/flake.nix" = {
      source = "/home/${myConfig.username}/.system-config/flake.nix";
    };
  };

  users.users.${myConfig.username} = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "networkmanager" ];
  };
}
