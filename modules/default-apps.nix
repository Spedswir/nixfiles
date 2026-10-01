{ config, pkgs, flake-inputs, ... }:

let
    vars = import ./vars.nix;
in
{
    imports =
    [
      ./terminal/kitty.nix
      ./productivity/communications.nix
      ./productivity/multimedia.nix
      ./productivity/documents.nix
      ./creative/media-editing.nix
    ];

    # Install Brave and ensure that specific extensions are installed.
    programs.chromium = {
      enable = true;
      package = pkgs.brave;
      extensions = [
        { id = "ghmbeldphafepmbegfdlkpapadhbakde"; } # Proton Pass
        { id = "jplgfhpmjnbigmhklmmbgecoobifkmpa"; } # Proton VPN
        { id = "lkhiljgmbeecmljiogckofcalncmfnfo"; } # Migaku
      ];
      commandLineArgs = [
        "--disable-features=WebRtcAllowInputVolumeAdjustment"
      ];
    };

    home.packages = with pkgs; [
        proton-vpn
        qdirstat
        nix-search-tv
        qbittorrent
        librewolf-bin
        gnome-calculator
        pciutils # For diagnostics, includes lspci
        kdePackages.isoimagewriter
        claude-code
    ];

    xdg.autostart = {
        enable = true;
        entries = [
            "${pkgs.proton-vpn}/share/applications/proton.vpn.app.gtk.desktop"
        ];
    };

    # Picks a random KDE wallpaper based on the time and day, shortly after
    # login and then every 15 minutes
    systemd.user.services.wallpaper-selector = {
        Unit = {
            Description = "Pick a random KDE wallpaper";
            After = [ "graphical-session.target" ];
            PartOf = [ "graphical-session.target" ];
        };
        Service = {
            Type = "oneshot";
            ExecStart = "${pkgs.bash}/bin/bash ${config.home.homeDirectory}${vars.nixConfDir}/scripts/wallpaperselector.sh";
        };
    };

    systemd.user.timers.wallpaper-selector = {
        Unit = {
            Description = "Change the KDE wallpaper every 15 minutes";
            PartOf = [ "graphical-session.target" ];
        };
        Timer = {
            # Give Plasma time to start before the first change
            OnActiveSec = "30s";
            OnUnitActiveSec = "15m";
        };
        Install.WantedBy = [ "graphical-session.target" ];
    };

    # Default applications. This makes ~/.config/mimeapps.list read-only, so
    # changing defaults in KDE System Settings won't stick - change them here.
    xdg.mimeApps = let
        defaults = {
            "text/html" = "brave-browser.desktop";
            "x-scheme-handler/http" = "brave-browser.desktop";
            "x-scheme-handler/https" = "brave-browser.desktop";
            "text/csv" = "onlyoffice-desktopeditors.desktop";
            "application/x-zerosize" = "org.kde.kate.desktop";
            "x-scheme-handler/freetube" = "freetube.desktop";
            "x-scheme-handler/gitkraken" = "gitkraken.desktop";
            "x-scheme-handler/x-github-client" = "github-desktop.desktop";
            "x-scheme-handler/x-github-desktop-dev-auth" = "github-desktop.desktop";
            "x-scheme-handler/claude-cli" = "claude-code-url-handler.desktop";
        };
    in {
        enable = true;
        defaultApplications = defaults;
        associations.added = defaults;
    };
    # KDE replaces mimeapps.list with a regular file, so overwrite it on rebuild
    xdg.configFile."mimeapps.list".force = true;
}
