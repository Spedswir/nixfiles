# Replace the contents of your existing NixOS timer module with this file.
# Keep it in the same location so these relative paths still resolve.
# This uses NixOS module syntax, not Home Manager module syntax.
{ lib, pkgs, ... }:

let
  vars = import ../../modules/vars.nix;
  gitUpdate = ../../scripts/gitpush.sh;
  username = "spedswir";

  mkGitService = repo: updateName: {
    description = "Update Git repository: ${updateName}";
    after = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    unitConfig.ConditionUser = username;

    path = with pkgs; [ bash git openssh coreutils ];

    environment = {
      GIT_ASKPASS = "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";
      GIT_TERMINAL_PROMPT = "0";
    };

    serviceConfig = {
      Type = "oneshot";
      WorkingDirectory = repo;
      # No User= setting: the user service manager supplies the identity.
    };

    script = ''
      exec ${pkgs.bash}/bin/bash ${gitUpdate} \
        ${lib.escapeShellArg repo} ${lib.escapeShellArg updateName}
    '';
  };

  mkGitTimer = name: {
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    unitConfig.ConditionUser = username;

    timerConfig = {
      # Start two minutes after the timer starts with the desktop session.
      OnActiveSec = "2m";
      OnUnitActiveSec = "45m";
      Unit = "${name}.service";
    };
  };
in
{
  systemd.user.services."git-update-obsidian" =
    mkGitService "${vars.gitRepoDir}/obsidian-archives" "Obsidian";

  systemd.user.services."git-update-other-files" =
    mkGitService "${vars.gitRepoDir}/OtherFiles" "OtherFiles";

  systemd.user.timers."git-update-obsidian" =
    mkGitTimer "git-update-obsidian";

  systemd.user.timers."git-update-other-files" =
    mkGitTimer "git-update-other-files";
}
