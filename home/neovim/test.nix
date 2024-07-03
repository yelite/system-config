{
  a,
  b,
}: let
  a = 1;
  x = ''
    adfasdf
  '';
in {
  b = let
    d = 3;
  in [
      1
    ];

  c = a: let c = 4; in [
    2
  ];

  f = 
    2 * 3;

  u = a: let c = 4; in  
    2;

  d = let
      y = 1;
      x = 1;
  in
    y;

  e = [
    1
  ];

  x = {
    a = 1;
  };

  environment.etc =
    a
    (name: value: {
      name = "nix/inputs/${name}";
      value = {source = value.outPath;};
    })
    (name: value: 
      3)
    x;
}
