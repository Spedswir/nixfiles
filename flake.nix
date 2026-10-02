{
  description = "Spedswir flake config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";


    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    obsidian-extensions = {
      url = "github:karaolidis/nix-obsidian-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # github.com/skelettor/nix-openlinkhub
    openlinkhub-flake = {
      url = "github:skelettor/nix-openlinkhub";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    proton-drive = {
      url = "github:tommasie/nix-proton-drive-cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
  let
    vars = import ./modules/vars.nix;

    # Builds a host from ./hosts/<host>/configuration.nix.
    # `host` is passed to every NixOS and Home Manager module, e.g. for the rebuild aliases.
    mkHost = host: extraModules: nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs host; };
      system = "x86_64-linux";
      modules = [
        ./hosts/${host}/configuration.nix
        inputs.home-manager.nixosModules.default
        # Hosts can override this in their own configuration.nix
        { networking.hostName = nixpkgs.lib.mkDefault "${vars.username}-${host}"; }
      ] ++ extraModules;
    };
  in
  {
    nixosConfigurations = {
      desktop = mkHost "desktop" [
        { nixpkgs.overlays = [ inputs.openlinkhub-flake.overlays.default ]; }
        inputs.openlinkhub-flake.nixosModules.openlinkhub
      ];
      laptop = mkHost "laptop" [ ];
      gaming-tv = mkHost "gaming-tv" [ ];
    };
  };
}
