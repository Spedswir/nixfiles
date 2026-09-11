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
        rebuild = "sudo nix flake update --flake ${vars.homeDir}${vars.nixConfDir}/; sudo nixos-rebuild switch --flake ${vars.homeDir}${vars.nixConfDir}/#laptop";
        rebuild-verbose = "sudo nix flake update --flake ${vars.homeDir}${vars.nixConfDir}/; sudo nixos-rebuild switch --flake ${vars.homeDir}${vars.nixConfDir}/#laptop --show-trace";
        rebuild-dry = "sudo nixos-rebuild dry-build --flake ${vars.homeDir}${vars.nixConfDir}/#laptop";
        rebuild-dry-verbose = "sudo nixos-rebuild dry-build --flake ${vars.homeDir}${vars.nixConfDir}/#laptop --show-trace";
        # This stops a rebuild of something like CUDE eating all of the CPU cores and RAM and crashing the PC.
        rebuild-limit = "sudo nix flake update --flake ${vars.homeDir}${vars.nixConfDir}/; sudo nixos-rebuild switch --flake ${vars.homeDir}${vars.nixConfDir}/laptop --cores 4 -j 2";
      };
    };
  };
}
