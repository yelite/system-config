final: prev: {
  wlroots = prev.wlroots.overrideAttrs (old: {
    # HACK: https://forums.developer.nvidia.com/t/nvidia-495-does-not-advertise-ar24-xr24-as-shm-formats-as-required-by-wayland-wlroots/194651
    #patches = (old.patches or []) ++ ( [../misc/wlroots.patch] );
    postPatch = ''
      sed -i 's/assert(argb8888 &&/assert(true || argb8888 ||/g' 'render/wlr_renderer.c'
    '';
  });
}
