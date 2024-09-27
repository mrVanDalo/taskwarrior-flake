{ inputs, ... }:
{
  perSystem =
    { pkgs, system, ... }:
    with pkgs;
    {
      packages.bugwarrior = callPackage ./bugwarrior { };
    };
}
