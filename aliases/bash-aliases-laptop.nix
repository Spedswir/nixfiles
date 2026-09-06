{ config, pkgs, lib, ... }:

let
  vars = import ../modules/vars.nix;
in
{
  programs = {
    command-not-found.enable = false;

    bash = {
      enable = true;

      shellAliases = {
        garbage = "sudo nix-collect-garbage --delete-older-than 14d";
        garbage-all = "sudo nix-collect-garbage";
        rebuild = "sudo nix flake update --flake ${vars.homeDir}/nix-conf/; sudo nixos-rebuild switch --flake ${vars.homeDir}/nix-conf/#laptop";
        rebuild-verbose = "sudo nix flake update --flake ${vars.homeDir}/nix-conf/; sudo nixos-rebuild switch --flake ${vars.homeDir}/nix-conf/#laptop --show-trace";
      };
    };
  };
}
