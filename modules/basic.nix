{ config, pkgs, ... }:

{
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
      source = "/home/liteye/.nixos-config/flake.nix";
    };
  };

  system.stateVersion = "21.05"; # Did you read the comment?

  users.users.liteye = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "networkmanager" ];
  };
}

