# Firewall ports for Steam Remote Play / in-home streaming and some games.
# This uses NixOS module syntax, not Home Manager module syntax.
# Imported by ../gaming.nix.
{ config, lib, pkgs, ... }:

{
  networking.firewall = {
    allowedTCPPorts = [ 27036 27037 ] ++ (lib.range 27015 27030);
    allowedUDPPorts = [ 4380 27036 ] ++ (lib.range 27000 27031);
    allowPing = true;
  };
}
