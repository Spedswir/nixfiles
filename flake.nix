{
  description = "Spedswir flake config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations.spedswir-linux-vm = nixpkgs.lib.nixosSystem {
      modules = [ ./configuration.nix ];
    };
  };
}
