{ config, pkgs, lib, ... }:

{
  imports = [
    ../modules/vars.nix
  ];

  programs = {
    command-not-found.enable = false;

    bash = {
      enable = true;

      shellAliases = {
        garbage = "sudo nix-collect-garbage --delete-older-than 14d";
        rebuild = "sudo nix flake update --flake /home/${config.vars.username}/nix-conf/; sudo nixos-rebuild switch --flake /home/${config.vars.username}/nix-conf/#laptop --impure";
      };
    };
  };
}
