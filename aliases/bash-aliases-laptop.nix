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
        rebuild = "sudo nix flake update --flake ${vars.homeDir}/nix-conf/; sudo nixos-rebuild switch --flake ${vars.homeDir}/nix-conf/#laptop";
        rebuild-verbose = "sudo nix flake update --flake ${vars.homeDir}/nix-conf/; sudo nixos-rebuild switch --flake ${vars.homeDir}/nix-conf/#laptop --show-trace";
        rebuild-dry = "sudo nixos-rebuild dry-build --flake ${vars.homeDir}/nix-conf/#laptop";
        rebuild-dry-verbose = "sudo nixos-rebuild dry-build --flake ${vars.homeDir}/nix-conf/#laptop --show-trace";
      };
    };
  };
}
