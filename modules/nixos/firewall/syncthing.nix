# Firewall ports for Syncthing: 22000 TCP/UDP for transfers, 21027 UDP for finding
# other machines on the LAN. Only applies when Syncthing is enabled.
# This uses NixOS module syntax, not Home Manager module syntax.
# Imported by ../freetube-sync.nix.
{ config, lib, pkgs, ... }:

{
  services.syncthing.openDefaultPorts = true;
}
