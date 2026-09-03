{
  description = "ekkekuru2 dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xremap-flake.url = "github:xremap/nix-flake";
  };

  outputs = { self, nixpkgs, home-manager, winapps, ... }@ inputs:
  let
    system = "x86_64-linux";
    overlays = [
      (final: prev: {
        ltspice = prev.ltspice.overrideAttrs (old: {
          src = prev.fetchurl {
            url = old.src.url;
            hash = "sha256-SF2r0tfYKT3nM6OZcZ9lOO/aSlS0ixgaFOBycRhphNM=";
          };
        });
      })
    ];
    pkgs = import nixpkgs {
      inherit overlays system;
    };
    sources = pkgs.callPackage ./nix/_sources/generated.nix {};
  in {
    nixosConfigurations.lemp13 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs system;
      };
      modules = [ ./nix/nixos/configuration.nix
        (
            {
              pkgs,
              system ? pkgs.system,
              ...
            }:
            {
              environment.systemPackages = [
                winapps.packages."${system}".winapps
                winapps.packages."${system}".winapps-launcher # optional
              ];
            }
          )

      ];
    };
    homeConfigurations =
      let
        makeHomeConfig =
          {
            modules ? [ ],
          }:
          inputs.home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = {
              inherit inputs sources;
            };
            modules = modules;
          };
      in
      {
        ekkekuru2 = makeHomeConfig { modules = [ ./nix/home-manager/desktop.nix ]; };
        /* desktop-min = makeHomeConfig { modules = [ ./nix/home-manager/desktop-min.nix ]; }; */
        headless = makeHomeConfig { modules = [ ./nix/home-manager/base.nix ];};
      };
  };
}
