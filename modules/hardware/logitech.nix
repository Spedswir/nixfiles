{ config, pkgs, ... }:

let
    # Starts Solaar hidden in the system tray at login (no window)
    solaarHidden = pkgs.makeDesktopItem {
        name = "solaar-hidden";
        desktopName = "Solaar";
        comment = "Logitech device manager";
        exec = "${pkgs.solaar}/bin/solaar --window=hide";
        icon = "solaar";
        terminal = false;
    };
in
{
    home.packages = [
        pkgs.solaar
    ];

    xdg.autostart = {
        enable = true;
        entries = [
            "${solaarHidden}/share/applications/solaar-hidden.desktop"
        ];
    };
}
