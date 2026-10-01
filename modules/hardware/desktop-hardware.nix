{ config, pkgs, ... }:

let
    # Starts the GoXLR daemon in the background at login (no window)
    goxlrDaemon = pkgs.makeDesktopItem {
        name = "goxlr-daemon";
        desktopName = "GoXLR Utility";
        comment = "A Tool for Configuring a GoXLR";
        exec = "${pkgs.goxlr-utility}/bin/goxlr-daemon";
        terminal = false;
    };
in
{
    imports = [
        ./logitech.nix
    ];

    home.packages = [
        pkgs.goxlr-utility
        pkgs.streamdeck-ui
    ];

    xdg.autostart = {
        enable = true;
        entries = [
            "${goxlrDaemon}/share/applications/goxlr-daemon.desktop"
        ];
    };
}
