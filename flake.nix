{
  description = "nix-darwin";

  inputs = {
    # Temporary pin until NixOS/nixpkgs#536365 reaches nixos-unstable.
    nixpkgs.url = "github:nixos/nixpkgs/d407951447dcd00442e97087bf374aad70c04cea";
    nixpkgs-small.url = "github:nixos/nixpkgs/nixos-unstable-small";

    pi-web-access = {
      url = "github:nicobailon/pi-web-access";
      flake = false;
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
      inputs.brew-src.follows = "brew-src";
    };

    brew-src = {
      url = "github:Homebrew/brew";
      flake = false;
    };

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    crmne-tap = {
      url = "github:crmne/homebrew-tap";
      flake = false;
    };
  };

  outputs = {
    nixpkgs-small,
    nix-darwin,
    home-manager,
    nix-homebrew,
    homebrew-core,
    homebrew-cask,
    homebrew-bundle,
    crmne-tap,
    pi-web-access,
    ...
  }: let
    user = "jackson";
    hostname = "Jacksons-MacBook-Pro";
    themeName = "spiderverse";
    theme = import ./lib/theme.nix {name = themeName;};
    pkgs-small = import nixpkgs-small {
      system = "aarch64-darwin";
      config.allowUnfree = true;
    };
  in {
    darwinConfigurations."${hostname}" = nix-darwin.lib.darwinSystem {
      specialArgs = {inherit user hostname theme;};

      modules = [
        ./modules/darwin

        nix-homebrew.darwinModules.nix-homebrew
        ({config, ...}: {
          nix-homebrew = {
            enable = true;
            user = user;
            autoMigrate = true;
            enableRosetta = false;
            enableFishIntegration = false;
            enableZshIntegration = false;
            enableBashIntegration = false;
            mutableTaps = false;
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
              "homebrew/homebrew-bundle" = homebrew-bundle;
              "crmne/homebrew-tap" = crmne-tap;
            };
          };

          homebrew.taps = [
            "homebrew/homebrew-core"
            "homebrew/homebrew-cask"
            "homebrew/homebrew-bundle"
            "crmne/homebrew-tap"
          ];
        })

        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            inherit user theme pkgs-small;
            piWebAccessSrc = pi-web-access;
          };
          home-manager.users.${user} = import ./home;
          home-manager.backupFileExtension = "backup";
        }
      ];
    };
  };
}
