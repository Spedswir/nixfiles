# Firewall port for Avahi (mDNS, 5353 UDP), used to find network printers and scanners.
# Only applies when Avahi is enabled.
# This uses NixOS module syntax, not Home Manager module syntax.
# Imported by ../printers-scanners.nix.
{ config, lib, pkgs, ... }:

{
  services.avahi.openFirewall = true;
}
