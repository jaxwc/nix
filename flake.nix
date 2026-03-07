{
  description = "Jackson's Modular Nix-Darwin Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    nix-darwin,
    home-manager,
    ...
  }: let
    user = "jackson";
    hostname = "Jacksons-MacBook-Pro";
  in {
    darwinConfigurations."${hostname}" = nix-darwin.lib.darwinSystem {
      specialArgs = {inherit user hostname;};

      modules = [
        ./modules/darwin

        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {inherit user;};
          home-manager.users.${user} = import ./home;
          home-manager.backupFileExtension = "backup";
        }
      ];
    };
  };
}
