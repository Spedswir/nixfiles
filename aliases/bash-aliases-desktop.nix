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
        rebuild = "sudo nix flake update --flake ${vars.homeDir}${vars.nixConfDir}/; sudo nixos-rebuild switch --flake ${vars.homeDir}${vars.nixConfDir}/#desktop";
        rebuild-verbose = "sudo nix flake update --flake ${vars.homeDir}${vars.nixConfDir}/; sudo nixos-rebuild switch --flake ${vars.homeDir}${vars.nixConfDir}/#desktop --show-trace";
        rebuild-dry = "sudo nixos-rebuild dry-build --flake ${vars.homeDir}${vars.nixConfDir}/#desktop";
        rebuild-dry-verbose = "sudo nixos-rebuild dry-build --flake ${vars.homeDir}${vars.nixConfDir}/#desktop --show-trace";
        # This stops a rebuild of something like CUDE eating all of the CPU cores and RAM and crashing the PC.
        rebuild-limit = "sudo nix flake update --flake ${vars.homeDir}${vars.nixConfDir}/; sudo nixos-rebuild switch --flake ${vars.homeDir}${vars.nixConfDir}/#desktop --cores 6 -j 3";

        # AI stuff
        ai-start = "${vars.homeDir}${vars.nixConfDir}/scripts/run_ai.sh";
        kcpp-start = "koboldcpp --config ${vars.homeDir}/Models/default.kcpps";
        st-start = "sillytavern --browserLaunchEnabled false";
      };
    };
  };
}
