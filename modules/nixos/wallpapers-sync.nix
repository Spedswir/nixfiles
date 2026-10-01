# Keeps the wallpapers repo up to date on every host (pull only, never pushes).
# Clones it first if it isn't there yet, e.g. on a fresh install.
# This uses NixOS module syntax, not Home Manager module syntax.
{ config, lib, pkgs, ... }:

let
  vars = import ../../modules/vars.nix;
  homeDir = config.users.users.${vars.username}.home;
  repo = "${homeDir}${vars.gitRepoDir}/wallpapers";
  repoUrl = "https://gitea.spedswir.com/spedswir/wallpapers.git";
in
{
  systemd.user.services."git-pull-wallpapers" = {
    description = "Pull Git repository: wallpapers";
    after = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    unitConfig.ConditionUser = "${vars.username}";

    path = with pkgs; [ git openssh coreutils ];

    environment = {
      GIT_ASKPASS = "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";
      GIT_TERMINAL_PROMPT = "0";
    };

    serviceConfig.Type = "oneshot";

    script = ''
      repo=${lib.escapeShellArg repo}
      if [ ! -d "$repo/.git" ]; then
        mkdir -p "$(dirname "$repo")"
        git clone ${lib.escapeShellArg repoUrl} "$repo"
      else
        git -C "$repo" pull --ff-only
      fi
    '';
  };

  systemd.user.timers."git-pull-wallpapers" = {
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    unitConfig.ConditionUser = "${vars.username}";

    timerConfig = {
      # Pull one minute after login, then every hour.
      OnActiveSec = "1m";
      OnUnitActiveSec = "1h";
      Unit = "git-pull-wallpapers.service";
    };
  };
}
