# Nix-managed environment

This machine is configured declaratively with nix-darwin and Home Manager.

- Treat `/Users/jackson/.config/nix` as the source of truth for user and system configuration.
- Do not directly create, edit, or delete generated configuration files in `$HOME` when they can be managed through Nix.
- For Pi configuration, edit `/Users/jackson/.config/nix/home/programs/pi.nix` or source files under `/Users/jackson/.config/nix/home/config/pi/`.
- Manage Pi files under `~/.pi/agent/` through Home Manager declarations in `home/programs/pi.nix`.
- Manage packages through the Nix configuration rather than imperative package installation whenever practical.
- Preserve existing unrelated changes in the Nix repository.
- After changing configuration, clearly state that the nix-darwin/Home Manager configuration must be applied. Do not run a system rebuild unless explicitly requested.
