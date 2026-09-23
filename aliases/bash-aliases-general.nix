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
        # NixOS Garbage Collection
        garbage = "sudo nix-collect-garbage --delete-older-than 14d";
        garbage-all = "sudo nix-collect-garbage";

        # NixOS updates
        nix-conf-pull = "cd ~/nix-conf/; git pull --rebase";
      };
    };
  };
}
