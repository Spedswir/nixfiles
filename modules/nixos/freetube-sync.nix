# Syncs FreeTube subscriptions, watch history and playlists between hosts with Syncthing.
# This uses NixOS module syntax, not Home Manager module syntax.
#
# Don't keep FreeTube open on two hosts at once. It rewrites its .db files whole,
# so changes made on both sides before a sync end up as .sync-conflict files.
#
# One-time setup:
#   1. Rebuild on each host, then get its device ID with:
#        syncthing cli --home ~/.local/state/syncthing show system | grep myID
#      (or open http://127.0.0.1:8384 -> Actions -> Show ID)
#   2. Paste the IDs into `devices` below and rebuild both hosts again.
{ config, lib, pkgs, ... }:

let
  vars = import ../../modules/vars.nix;
  homeDir = config.users.users.${vars.username}.home;
  freetubeDir = "${homeDir}/.config/FreeTube";

  # Device IDs aren't secret. Hosts with an empty ID are left out until it's filled in.
  devices = lib.filterAttrs (_: id: id != "") {
    "${vars.username}-desktop" = "OU3QQFA-53EPLJH-O6BM7IR-RWGBHSW-5TWIOQN-66EW5CE-GQKVOX3-JZRLRQA";
    "${vars.username}-laptop" = "2FCGJ6S-SPXBCKE-BOJSBM3-H3K6KKI-XHOBJZ2-42ZR6H2-YFFHZEZ-GWDZFAG";
  };

  # Only these files are synced, everything else in the folder (caches, cookies, etc.) is ignored.
  # settings.db is left out so each host keeps its own settings.
  syncedFiles = [ "profiles.db" "history.db" "playlists.db" "search-history.db" ];
in
{
  imports = [ ./firewall/syncthing.nix ];

  services.syncthing = {
    enable = true;
    user = vars.username;
    group = "users";
    dataDir = homeDir;
    configDir = "${homeDir}/.local/state/syncthing";
    # Anything added through the web UI gets reset on rebuild.
    overrideDevices = true;
    overrideFolders = true;

    settings = {
      devices = lib.mapAttrs (_: id: { inherit id; }) devices;
      folders.freetube = {
        path = freetubeDir;
        devices = lib.attrNames (lib.removeAttrs devices [ config.networking.hostName ]);
        ignorePatterns = map (f: "!/${f}") syncedFiles ++ [ "*" ];
        # Keep 5 old copies of each file in .stversions, just in case.
        versioning = {
          type = "simple";
          params.keep = "5";
        };
      };
      options.urAccepted = -1; # Don't send usage reports
    };
  };

  # Make sure the folder exists before Syncthing starts, e.g. on a fresh install.
  systemd.tmpfiles.rules = [
    "d ${freetubeDir} 0755 ${vars.userId-string} ${vars.groupId-string}"
  ];
}
