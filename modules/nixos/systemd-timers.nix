{ lib, pkgs, ... }:

let
  gitUpdate = ../../scripts/gitpush.sh;
  vars = import ../../modules/vars.nix;

  username = "${vars.username}";

  mkGitService = repo: {
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];

    path = with pkgs; [
      bash
      git
      openssh
      coreutils
    ];

    serviceConfig = {
      Type = "oneshot";
      User = username;
      WorkingDirectory = repo;
    };

    script = ''
      exec ${pkgs.bash}/bin/bash ${gitUpdate} ${lib.escapeShellArg repo}
    '';
  };

  mkGitTimer = name: {
    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnBootSec = "2m";
      OnUnitActiveSec = "45m";
      Unit = "${name}.service";
    };
  };
in
{
  systemd.services."git-update-obsidian" =
    mkGitService "${vars.gitRepoDir}/obsidian-archives";

  systemd.services."git-update-other-files" =
    mkGitService "${vars.gitRepoDir}/OtherFiles";

  systemd.timers."git-update-obsidian" =
    mkGitTimer "git-update-obsidian";

  systemd.timers."git-update-other-files" =
    mkGitTimer "git-update-other-files";
}
