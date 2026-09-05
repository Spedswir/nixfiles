{
  description = "Spedswir flake config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/desktop/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };
      laptop = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/laptop/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };
    };
  };
}
