# Two-way sync between Proton Drive and ~/Documents/ProtonDrive using rclone.
# This uses Home Manager module syntax.
#
# One-time setup after rebuilding:
#   1. rclone config    (new remote named "protondrive", type "Proton Drive")
#   2. rclone bisync protondrive: ~/Documents/ProtonDrive --resync --create-empty-src-dirs -v
{ config, pkgs, ... }:

let
  # Local folder to keep in sync (avoid spaces in the name to keep quoting simple)
  localDir = "${config.home.homeDirectory}/Documents/ProtonDrive";
  # Use "protondrive:SomeFolder" to sync only one folder instead of the whole drive.
  remote = "protondrive:";
in
{
  home.packages = [ pkgs.rclone ];

  systemd.user.services.protondrive-sync = {
    Unit = {
      Description = "Two-way sync between Proton Drive and ${localDir}";
      After = [ "network-online.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p ${localDir}";
      ExecStart = ''
        ${pkgs.rclone}/bin/rclone bisync ${remote} ${localDir} \
          --create-empty-src-dirs \
          --resilient --recover \
          --conflict-resolve newer \
          --max-lock 2m \
          -v
      '';
    };
  };

  systemd.user.timers.protondrive-sync = {
    Unit.Description = "Run Proton Drive sync every 15 minutes";
    Timer = {
      OnBootSec = "2m";
      OnUnitActiveSec = "15m";
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
