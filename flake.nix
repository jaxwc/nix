{
  description = "nix-darwin";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

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
  };

  outputs = {
    nix-darwin,
    home-manager,
    nix-homebrew,
    homebrew-core,
    homebrew-cask,
    homebrew-bundle,
    ...
  }: let
    user = "jackson";
    hostname = "Jacksons-MacBook-Pro";
    themeName = "tokyo-night-storm";
    theme = import ./lib/theme.nix {name = themeName;};
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
            };
          };

          homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
        })

        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {inherit user theme;};
          home-manager.users.${user} = import ./home;
          home-manager.backupFileExtension = "backup";
        }
      ];
    };
  };
}
