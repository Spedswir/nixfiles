# Firewall ports for qBittorrent, so peers can connect in.
# This uses NixOS module syntax, not Home Manager module syntax.
# Imported by the desktop and laptop configuration.nix.
#
# Off the VPN: qBittorrent's own port (Tools > Options > Connection). The router has no UPnP,
# so it also needs a port forward on the router to this machine.
#
# On Proton VPN: Proton's port forwarding hands out a random port each time it connects
# (shown in the Proton VPN app). Set qBittorrent's port to it. That port can't be known in
# advance, so all high ports are allowed, but only on the VPN interface (proton0). Nothing
# can reach it except through Proton's forwarded port.
{ config, lib, pkgs, ... }:

let
  qbittorrentPort = 45907;
in
{
  networking.firewall = {
    allowedTCPPorts = [ qbittorrentPort ];
    allowedUDPPorts = [ qbittorrentPort ];

    interfaces.proton0 = {
      allowedTCPPortRanges = [ { from = 1024; to = 65535; } ];
      allowedUDPPortRanges = [ { from = 1024; to = 65535; } ];
    };
  };
}
