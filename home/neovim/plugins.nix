# TODO move to flake
{ pkgs, ... }:
{
  stabilize = pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "stabilize";
    version = "master";
    src = pkgs.fetchFromGitHub {
      owner = "luukvbaal";
      repo = "stabilize.nvim";
      rev = "master";
      sha256 = "sha256-LIoKVG3xl1e/AxhAGWl0tOOZ/Ejv7x08Bv2xZ0gmy+g=";
    };
  };

  session-lens = pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "session-lens";
    version = "master";
    src = pkgs.fetchFromGitHub {
      owner = "rmagatti";
      repo = "session-lens";
      rev = "main";
      sha256 = "sha256-U1sRWLp+PCx29pQyueAppd/S3pI+SbDvYK5Ih5SZx3A=";
    };
  };

  mapx = pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "mapx";
    version = "master";
    src = pkgs.fetchFromGitHub {
      owner = "b0o";
      repo = "mapx.nvim";
      rev = "main";
      sha256 = "sha256-E/RESkgC9lKcYUX0YIZQeNGiPI68eIEOamaAo75YbSc=";
    };
  };

  lspsaga-nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "lspsaga-nvim";
    version = "master";
    src = pkgs.fetchFromGitHub {
      owner = "tami5";
      repo = "lspsaga.nvim";
      rev = "cb66f44ad366852ca8bc2b2199d40836260fadf5";
      sha256 = "sha256-qH6xjWzzwRY0wpf3mn6KsiJ9//thQuYfe0URcEdxDgM=";
    };
  };

  navigator = pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "navigator";
    version = "master";
    src = pkgs.fetchFromGitHub {
      owner = "ray-x";
      repo = "navigator.lua";
      rev = "99b7b1c502149c2f153510f1daa5580353fddcbe";
      sha256 = "sha256-MMUhwejYBtHnF8FVWkRRiH8FNWEsPlx7fP+AYr8Id7k=";
    };
  };

  lightspeed-nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "lightspeed-nvim";
    version = "master";
    src = pkgs.fetchFromGitHub {
      owner = "ggandor";
      repo = "lightspeed.nvim";
      rev = "adc7aed74e940cef32c2aa75bfb7aebe2d4466c7";
      sha256 = "sha256-0l/u1y7LxzaW6lwAfPu9uUUmv11A2/5UCh1Mmu7iREU=";
    };
  };

  coq_nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "coq_nvim";
    version = "master";
    src = pkgs.fetchFromGitHub {
      owner = "ms-jpq";
      repo = "coq_nvim";
      rev = "53155d8fdcac84072d5dc877da7a511f6be11569";
      sha256 = "sha256-beIyk4M2ayn5BFZ+QjXR951ylFcnmGMCscfO8e4l3G0=";
    };
  };

  autosave = pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "autosave";
    version = "master";
    src = pkgs.fetchFromGitHub {
      owner = "Pocco81";
      repo = "AutoSave.nvim";
      rev = "140c47757051706c484525472296ca5213fdf598";
      sha256 = "sha256-l1REQsT3+hYIf+XReT2DdQOvDyWiNWgvronhgHq0TQg=";
    };
  };
}
