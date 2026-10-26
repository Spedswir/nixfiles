# Disk partitioning and USB flashing tools.
# This uses NixOS module syntax, not Home Manager module syntax.
{ config, pkgs, ... }:

{
  # KDE Partition Manager. The NixOS module (rather than just the package) sets up
  # the kpmcore polkit helper it needs to get root access.
  programs.partition-manager.enable = true;

  environment.systemPackages = [
    (pkgs.callPackage ../productivity/balena-etcher.nix { }) # balenaEtcher
  ];
}
