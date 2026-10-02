{ config, pkgs, lib, host, ... }:

let
  vars = import ../modules/vars.nix;
  # `host` is the flake output name (desktop, laptop, gaming-tv), passed in from flake.nix.
  flake = "${config.home.homeDirectory}${vars.nixConfDir}/#${host}";
  flakeUpdate = "sudo nix flake update --flake ${config.home.homeDirectory}${vars.nixConfDir}/";

  # Build limits for rebuild-limit. Hosts not listed use the default.
  rebuildLimits = {
    desktop = "--cores 6 -j 3";
  };
  rebuildLimit = rebuildLimits.${host} or "--cores 4 -j 2";
in
{
  programs = {
    command-not-found.enable = false;

    bash = {
      enable = true;

      shellAliases = {
        # NixOS rebuilds for this host
        rebuild = "${flakeUpdate}; sudo nixos-rebuild switch --flake ${flake}";
        rebuild-verbose = "${flakeUpdate}; sudo nixos-rebuild switch --flake ${flake} --show-trace";
        rebuild-dry = "sudo nixos-rebuild dry-build --flake ${flake}";
        rebuild-dry-verbose = "sudo nixos-rebuild dry-build --flake ${flake} --show-trace";
        # This stops a rebuild of something like CUDE eating all of the CPU cores and RAM and crashing the PC.
        rebuild-limit = "${flakeUpdate}; sudo nixos-rebuild switch --flake ${flake} ${rebuildLimit}";

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
