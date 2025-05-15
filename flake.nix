{
  description = "ekkekuru2 dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@ inputs:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    sources = pkgs.callPackage ./nix/_sources/generated.nix {};
  in {
    nixosConfigurations.lemp13 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./nix/nixos/configuration.nix];
    };
    homeConfigurations."ekkekuru2" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit inputs sources;
      };
      modules = [
        ./nix/home-manager/home-manager.nix
      ];
    };
  };
}
