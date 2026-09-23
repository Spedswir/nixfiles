{ config, pkgs, ... }:

{
    systemd.timers."hello-world" = {
        wantedBy = [
            "timers.target"
        ];
        timerConfig = {
            OnBootSec = "5m";
            OnUnitActiveSec = "5m";
            Unit = "hello-world.service";
        };
    };
}
