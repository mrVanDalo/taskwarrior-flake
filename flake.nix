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
    inputs@{
      flake-parts,
      taskshell,
      self,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      top@{
        config,
        lib,
        inputs,
        ...
      }:
      {
        imports = [
          ./nix/formatter.nix
        ];
        systems = [
          "x86_64-linux"
          "aarch64-linux"
          "aarch64-darwin"
          "x86_64-darwin"
        ];

        perSystem =
          {
            pkgs,
            system,
            self',
            ...
          }:
          {
            packages.taskchampion-sync-server = pkgs.taskchampion-sync-server;
            packages.taskwarrior = pkgs.taskwarrior3;
            packages.tasksh = taskshell.packages.${system}.default;
            packages.taskwarrior-hooks = pkgs.callPackage ./pkgs/taskwarrior-hooks { };
            packages.bugwarrior = pkgs.callPackage ./pkgs/bugwarrior { };

            checks = {
              #taskchampion-sync-server = pkgs.nixosTests.taskchampion-sync-server;

              # Test that overlay works by building a minimal NixOS config with it
              overlay-test =
                (inputs.nixpkgs.lib.nixosSystem {
                  inherit system;
                  modules = [
                    (
                      { pkgs, ... }:
                      {
                        nixpkgs.overlays = [ top.self.overlays.default ];
                        boot.loader.grub.enable = false;
                        fileSystems."/" = {
                          device = "none";
                          fsType = "tmpfs";
                        };
                        system.stateVersion = "25.11";

                        environment.systemPackages = with pkgs; [
                          #taskchampion-sync-server
                          #taskwarrior
                          tasksh
                          taskwarrior-hooks
                          bugwarrior
                        ];
                      }
                    )
                  ];
                }).config.system.build.toplevel;
            };

          };

        flake =
          { ... }:
          {

            overlays.default = final: prev: {
              taskchampion-sync-server = self.packages.${final.system}.taskchampion-sync-server;
              taskwarrior = self.packages.${final.system}.taskwarrior;
              tasksh = self.packages.${final.system}.tasksh;
              taskwarrior-hooks = self.packages.${final.system}.taskwarrior-hooks;
              bugwarrior = self.packages.${final.system}.bugwarrior;
            };

            hmModules.bugwarrior = {
              imports = [ ./home-manager/bugwarrior ];
            };

          };
      }
    );
}
