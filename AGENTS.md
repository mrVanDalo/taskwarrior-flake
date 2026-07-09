# CLAUDE.md - taskwarrior-flake

## Project Overview

**Maintenance**: Keep this file up to date when modifying the project,
especially the **Structure** section when adding/removing files.

A **specialized Nix channel** for Taskwarrior v3 tools that tracks
`nixos-unstable` as closely as possible while guaranteeing stability. Solves the
"fresh but broken" problem of unstable channels.

**How it works**: CI updates `flake.lock` weekly, but **only commits if all
tests pass**. Users get the latest packages that are proven to work together.

**Use case**: Add this flake as input to your NixOS configuration for
always-fresh, always-tested taskwarrior tools.

**Author**: Ingolf Wagner | **Repo**:
https://github.com/mrVanDalo/taskwarrior-flake

## Quick Commands

```bash
nix flake check      # Run all checks (CI command)
nix build .#<pkg>    # Build specific package
nix fmt              # Format code (nixfmt + deno)
```

## Structure

```
flake.nix                    # Main flake (flake-parts based)
nix/
  formatter.nix              # treefmt config (nixfmt + deno)
pkgs/
  bugwarrior/default.nix     # Python issue tracker integration
  taskwarrior-hooks/default.nix  # Rust hooks library
home-manager/
  bugwarrior/default.nix     # HM module with enable/config options
.github/workflows/ci.yaml    # Weekly auto-update + check
```

## Packages Exported

| Package                    | Description                            |
| -------------------------- | -------------------------------------- |
| `taskwarrior`              | Taskwarrior v3                         |
| `taskchampion-sync-server` | Sync server                            |
| `tasksh`                   | Custom taskshell (no hardcoded colors) |
| `taskwarrior-hooks`        | Rust hooks library                     |
| `bugwarrior`               | Issue tracker to Taskwarrior           |

## Key Technical Details

- **Nix**: Uses `flake-parts` architecture, `nixos-unstable` channel
- **Platforms**: x86_64-linux, aarch64-linux, aarch64-darwin, x86_64-darwin
- **Python**: Uses `python3Packages` (nixpkgs default) for bugwarrior; avoids
  pinning to a specific minor version to prevent upstream incompatibilities
- **Overlay**: Exports `overlays.default` for NixOS integration
- **Testing**: `overlay-test` validates overlay works in NixOS configs

## Conventions

### Git

- **ALWAYS** commit without signing: `--no-gpg-sign`
- Use Gitmoji prefixes: `:sparkles:` (feature), `:bug:` (fix), `:arrow_up:`
  (deps), `:construction_worker:` (CI)
- Main branch: `main`

### Nix Code

- Use `callPackage` pattern for packages
- `rustPlatform.buildRustPackage` for Rust
- Modular structure: formatters in `./nix/`, packages in `./pkgs/`
- Pass `top` context for accessing `top.self.overlays.default`

### Adding a Package

1. Create `pkgs/<name>/default.nix`
2. Add to overlay in `flake.nix`
3. Add test if needed in `flake.nix` checks

## CI Workflow (The Core Mechanism)

Runs weekly (Sunday 00:00 UTC) and on manual trigger:

1. `nix flake update` - Pull latest from nixos-unstable
2. `nix flake check` - **All tests must pass**
3. Only commits `flake.lock` if tests succeed

This ensures the committed `flake.lock` always represents a **tested, working
state**. If upstream breaks something, the update is rejected and users stay on
the last known-good version.

## Flake Architecture

```nix
# Key pattern in flake.nix
perSystem = { pkgs, top, ... }: {
  # Access overlay: top.self.overlays.default
  # Access packages: pkgs extended with overlay
};
```

Home Manager module pattern:

```nix
services.bugwarrior = {
  enable = true;
  config = { /* TOML config as Nix attrs */ };
};
```
