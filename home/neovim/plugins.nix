# TODO move to flake
{pkgs, ...}:
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
