{ config, pkgs, ... }:

let
    vars = import ../../modules/vars.nix;
in
{
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # enables support for SANE scanners
  hardware.sane.enable = true;
  users.users.${vars.username}.extraGroups = [ "scanner" "lp" ];
}
