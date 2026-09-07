{ config, pkgs, ... }:

let
    vars = import ../../modules/vars.nix;
    hostServer = "10.0.0.220";
    automount_opts = "x-systemd.automount,nofail,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,uid=${vars.userId},gid=${vars.groupId},file_mode=0777,dir_mode=0777,x-gvfs-show,credentials=/etc/.smbcred";
in
{
    systemd.tmpfiles.rules = [
        "d /mnt/server 0777 ${vars.userId} ${vars.groupId}"
        "d /mnt/server/Multimedia 0777 ${vars.userId} ${vars.groupId}"
        "d /mnt/server/Personal 0777 ${vars.userId} ${vars.groupId}"
        "d /mnt/server/General 0777 ${vars.userId} ${vars.groupId}"
    ];

    fileSystems = {
        "/mnt/server/Multimedia" = {
            device = "//${hostServer}/Multimedia";
            fsType = "cifs";
            options = ["${automount_opts}"];
        };
        "/mnt/server/Personal" = {
            device = "//${hostServer}/MikeStuff";
            fsType = "cifs";
            options = ["${automount_opts}"];
        };
        "/mnt/server/General" = {
            device = "//${hostServer}/General";
            fsType = "cifs";
            options = ["${automount_opts}"];
        };
    };
}
