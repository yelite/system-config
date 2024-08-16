{
  lib,
  hostPlatform,
  config,
  ...
}:
lib.mkIf hostPlatform.isDarwin {
  home.file."${config.programs.firefox.configPath}/profiles.ini".text =
    lib.mkForce
    ''
      [Profile0]
      Name=dev-edition-default
      IsRelative=1
      Path=Profiles/main.dev-edition-default

      [General]
      StartWithLastProfile=1
    '';
}
