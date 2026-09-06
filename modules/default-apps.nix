{ config, pkgs, ... }:

{
    imports =
    [ # Include the results of the hardware scan.
      ./terminal/kitty.nix
      ./productivity/communications.nix
      ./productivity/multimedia.nix
    ];

    programs.qdirstat.enable = true;
    programs.nerd-fonts.enable = true;
    programs.brave-bin.enable = true;
    programs.firefox.enable = true;

    home.packages = [
        pkgs.protonvpn-gui
    ];
}
