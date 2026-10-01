{ config, pkgs, ... }:

let
    vars = import ./vars.nix;
in
{
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
}
