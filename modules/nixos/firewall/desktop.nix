# Desktop-only firewall ports.
# This uses NixOS module syntax, not Home Manager module syntax.
# Imported by hosts/desktop/configuration.nix.
{ config, lib, pkgs, ... }:

{
  networking.firewall = {
    enable = true;

    # Purpose not recorded when it was opened. SillyTavern's default port is 8000.
    allowedTCPPorts = [ 8000 ];
    allowedUDPPorts = [ 8000 ];
  };
}
