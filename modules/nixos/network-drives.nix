{ config, pkgs, ... }:

let
    vars = import ../../modules/vars.nix;
    hostServer = "10.0.0.220";
    automount_opts = "x-systemd.automount,nofail,uid=${vars.userId-string},gid=${vars.groupId-string},file_mode=0777,dir_mode=0777,x-gvfs-show,credentials=/etc/.smbcred";
in
{
    systemd.tmpfiles.rules = [
        # Root only. The CIFS mounts run as root, so they can still read it. Edit with: sudoedit /etc/.smbcred
        "f /etc/.smbcred 0600 root root - username=\\npassword=\\n"
        # "f" only applies to new files, "z" also fixes the owner/mode of an existing one
        "z /etc/.smbcred 0600 root root -"
        "d /mnt/server 0777 ${vars.userId-string} ${vars.groupId-string}"
        "d /mnt/server/Multimedia 0777 ${vars.userId-string} ${vars.groupId-string}"
        "d /mnt/server/Personal 0777 ${vars.userId-string} ${vars.groupId-string}"
        "d /mnt/server/General 0777 ${vars.userId-string} ${vars.groupId-string}"
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
