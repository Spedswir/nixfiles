{ config, pkgs, lib, ... }:

let
  vars = import ../modules/vars.nix;
  updateStream = config.vars-options.updateStream;
in
{
  programs = {
    command-not-found.enable = false;

    bash = {
      enable = true;

      shellAliases = {
        garbage = "sudo nix-collect-garbage --delete-older-than 14d";
        garbage-all = "sudo nix-collect-garbage";
        rebuild = "sudo nix flake update --flake ${vars.homeDir}/nix-conf/; sudo nixos-rebuild switch --flake ${vars.homeDir}/nix-conf/#${updateStream}";
        rebuild-verbose = "sudo nix flake update --flake ${vars.homeDir}/nix-conf/; sudo nixos-rebuild switch --flake ${vars.homeDir}/nix-conf/#${updateStream} --show-trace";
        rebuild-dry = "sudo nixos-rebuild dry-build switch --flake ${vars.homeDir}/nix-conf/#${updateStream}";
        rebuild-dry-verbose = "sudo nixos-rebuild dry-build switch --flake ${vars.homeDir}/nix-conf/#${updateStream} --show-trace";
      };
    };
  };
}
