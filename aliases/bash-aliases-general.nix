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
      };
    };
  };
}
