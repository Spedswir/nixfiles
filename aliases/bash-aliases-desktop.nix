{ config, pkgs, lib, ... }:

let
  vars = import ../modules/vars.nix;
in
{
  imports =
  [
    ./bash-aliases-general.nix
  ];

  programs = {
    bash = {
      shellAliases = {
        rebuild = "sudo nix flake update --flake ${vars.homeDir}/nix-conf/; sudo nixos-rebuild switch --flake ${vars.homeDir}/nix-conf/#desktop";
        rebuild-verbose = "sudo nix flake update --flake ${vars.homeDir}/nix-conf/; sudo nixos-rebuild switch --flake ${vars.homeDir}/nix-conf/#desktop --show-trace";
        rebuild-dry = "sudo nixos-rebuild dry-build switch --flake ${vars.homeDir}/nix-conf/#desktop";
        rebuild-dry-verbose = "sudo nixos-rebuild dry-build switch --flake ${vars.homeDir}/nix-conf/#desktop --show-trace";
      };
    };
  };
}
