{...}: {
  perSystem = {
    system,
    pkgs,
    ...
  }: {
    formatter = pkgs.alejandra;
  };
}
