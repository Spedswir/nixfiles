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
        nix-conf-pull = "cd ${config.home.homeDirectory}${vars.nixConfDir}; git pull --rebase";

        # NixOS full cleanup - This can take a long time
        cleanup = "garbage; nix store optimise";
      };

      initExtra = ''
        # usage: git-commit "message"
        git-commit() {
          git add . && git commit -m "$1" && git push
        }
      '';
    };
  };
}
