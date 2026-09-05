{ config, pkgs, lib, ... }:

{
  programs = {
    command-not-found.enable = false;

    bash = {
      enable = true;

      shellAliases = {
        garbage = "sudo nix-collect-garbage --delete-older-than 14d";
        rebuild = "sudo nix flake update; sudo nixos-rebuild switch --flake /home/${username}/nix-conf/#laptop";
      };
    };
  };
}
