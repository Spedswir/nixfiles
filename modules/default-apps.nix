{ config, pkgs, ... }:

{
    imports =
    [ # Include the results of the hardware scan.
      ./terminal/kitty.nix
      ./productivity/communications.nix
      ./productivity/multimedia.nix
    ];

    programs.brave.enable = true;
    programs.firefox.enable = true;

    home.packages = [
        pkgs.proton-vpn
        pkgs.qdirstat
    ];
}
