{ config, pkgs, ... }:

let
    automount_opts = "x-systemd.automount,noauto,nofail,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,uid=1000,gid=1000,file_mode=0777,dir_mode=0777,x-gvfs-show";
in
{
    fileSystems = {
        "/mnt/Multimedia" = {
            device = "//10.0.0.220/Multimedia";
            fsType = "cifs";
            options = ["${automount_opts},credentials=/etc/.smbcred"];
        };
        "/mnt/Personal" = {
            device = "//10.0.0.220/MikeStuff";
            fsType = "cifs";
            options = ["${automount_opts},credentials=/etc/.smbcred"];
        };
        "/mnt/General" = {
            device = "//10.0.0.220/General";
            fsType = "cifs";
            options = ["${automount_opts},credentials=/etc/.smbcred"];
        };
    };
}
