{
  description = "taskwarrior packages and modules";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
    taskshell.url = "github:mrvandalo/taskshell"; # tasksh without hardcoded color codes
    taskshell.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{ flake-parts, taskshell, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./nix/formatter.nix
        ./nix/devshells.nix
      ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      perSystem =
        { pkgs, system, ... }:
        with pkgs;
        {
          packages.tasksh = taskshell.packages.${system}.default;
          packages.taskwarrior-hooks = callPackage ./pkgs/taskwarrior-hooks { };
          packages.bugwarrior = callPackage ./pkgs/bugwarrior { };
        };
      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.
        hmModules.bugwarrior = import ./home-manager/bugwarrior;
      };
    };
}
