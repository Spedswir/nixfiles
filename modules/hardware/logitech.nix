{ config, pkgs, ... }:

{
    home.packages = [
        pkgs.solaar
    ];

    xdg.autostart = {
        enable = true;
        entries = [
            "${pkgs.solaar}/share/applications/solaar.desktop"
        ];
    };
}
