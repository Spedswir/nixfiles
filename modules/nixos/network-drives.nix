{ config, pkgs, ... }:

let
    vars = import ../../modules/vars.nix;
    hostServer = "10.0.0.220";
    automount_opts = "x-systemd.automount,nofail,uid=${vars.userId-string},gid=${vars.groupId-string},file_mode=0777,dir_mode=0777,x-gvfs-show,credentials=/etc/.smbcred";
in
{
    systemd.services.create-foo-conf = {
      script = ''
        cat > /etc/.smbcred << EOF
        username=
        password=
        EOF
        chown ${vars.userId-string}:gid=${vars.groupId-string} /etc/.smbcred
        chmod 775 /etc/.smbcred
      '';
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      unitConfig.ConditionPathExists = "!/etc/.smbcred";
      serviceConfig.Type = "oneshot";
    };

    systemd.tmpfiles.rules = [
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
