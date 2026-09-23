{ config, pkgs, ... }:

let
    gitUpdate = "../../scripts/gitpush.sh"
    vars = import ../../modules/vars.nix;
in
{
    systemd.timers."git-update-obsidian" = {
        wantedBy = [
            "timers.target"
        ];
        timerConfig = {
            OnBootSec = "2m";
            OnUnitActiveSec = "45m";
            Unit = "${gitUpdate} \"${vars.gitRepoDir}/obsidian-archives\"";
        };
    };
}
