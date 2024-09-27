{ inputs, ... }:
{
  perSystem =
    { pkgs, system, ... }:
    with pkgs;
    {
      packages.taskwarrior-hooks = callPackage ./taskwarrior-hooks { };
      packages.bugwarrior = callPackage ./bugwarrior { };
    };
}
