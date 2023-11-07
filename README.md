This repo contains config for my devices. It uses

- [Nix Flake](https://nixos.wiki/wiki/Flakes)
- [Home Manager](https://github.com/nix-community/home-manager)
- [NixOS](https://nixos.org)
- [nix-darwin](https://github.com/LnL7/nix-darwin)

This repo is not supposed to be used by others as it's highly personalized. However, there
are a few tricks that might be valuable to those who want to configure their system with Nix.

- Use direnv to load Neovim lua modules directly from repo instead of Nix store.
  - This speeds up the edit-run loop when tweaking Neovim config, compared to the typical
    workflow that involves `nixos-rebuild`.
  - Check [.envrc](https://github.com/yelite/system-config/blob/4f6e51ec543e00d1d30590ee6fb05a2b72a5efd2/.envrc#L1)
- Use subflake to manage extra plugins for Neovim and fish.
  - It uses (https://github.com/ursi/get-flake) to eval flake by relative path.
    (`builtins.getFlake` cannot eval flake by path, unless under `--impure`.)
  - Alternatively it can use path-based flake input, but there is some UX issue on the
    implementation (see https://github.com/NixOS/nix/issues/3978#issuecomment-952418478).
  - Check [flake.nix](https://github.com/yelite/system-config/blob/4f6e51ec543e00d1d30590ee6fb05a2b72a5efd2/flake.nix#L25)
    and [overlays/flakes/neovim](https://github.com/yelite/system-config/blob/4f6e51ec543e00d1d30590ee6fb05a2b72a5efd2/overlays/flakes/neovim/)
