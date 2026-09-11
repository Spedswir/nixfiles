{ config, pkgs, ... }:

{
    imports =
    [ # Include the results of the hardware scan.
      ./terminal/kitty.nix
      ./productivity/communications.nix
      ./productivity/multimedia.nix
      ./productivity/documents.nix
    ];

    programs.brave.enable = true;

    home.packages = with pkgs; [
        proton-vpn
        qdirstat
        nix-search-tv
        qbittorrent
        librewolf
    ];
}
