{ config, pkgs, ... }:

let
    vars = import ../../modules/vars.nix;
in
{
  imports = [ ./firewall/printers.nix ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # enables support for SANE scanners
  hardware.sane.enable = true;
  # eSCL/AirScan backend for network scanners (e.g. Canon TS9560a)
  hardware.sane.extraBackends = [ pkgs.sane-airscan ];
  users.users.${vars.username}.extraGroups = [ "scanner" "lp" ];

  # mDNS discovery for network printers/scanners
  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };
}
