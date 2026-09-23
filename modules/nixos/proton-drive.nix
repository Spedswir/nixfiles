{ config, pkgs, secrets, ... }:

{
  systemd = tmpfiles.rules = [ "d /mnt/protondrive 0755 root root" ];
  environment.etc."rclone-proton.conf".text = '' [remote] type = protondrive username = ${secrets.proton.email} password = ${secrets.proton.pass}'';

  # Mount proton drive to /mnt/protondrive
  serviceConfig = {
    Type = "simple";
    Restart = "on-failure";
    RestartSec = "15s";

    StateDirectory = "rclone-USER"; # Change to rclone-YOURUSER for perms?

    ExecStartPre = ''
      /bin/sh -c 'if [ ! -f "/var/lib/rclone-protondrive/rclone.conf" ]; then ${pkgs.coreutils}/bin/cp /etc/rclone-proton.conf /var/lib/rclone-protondrive/rclone.conf; fi'
    '';

    ExecStart = ''
      ${pkgs.rclone}/bin/rclone mount \
        --config=/var/lib/rclone-protondrive/rclone.conf \
        --allow-other \
        --vfs-cache-mode full \
        remote:/ /mnt/protondrive
    '';

    ExecStop = "${pkgs.fuse}/bin/fusermount -u /mnt/protondrive";
  };

  wantedBy = [ "multi-user.target" ];
}




