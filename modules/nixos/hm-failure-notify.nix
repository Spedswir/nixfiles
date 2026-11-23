{ pkgs, ... }:

# Desktop notification when the Home Manager activation fails (on a rebuild or at boot).
# When it fails, user packages and dotfiles silently stay on the previous generation;
# nixos-rebuild only mentions it in a one-line warning near the end of its output.
let
  vars = import ../vars.nix;
  unit = "home-manager-${vars.username}.service";
in
{
  systemd.services."home-manager-${vars.username}".onFailure = [ "hm-failure-notify.service" ];

  systemd.services.hm-failure-notify = {
    description = "Notify ${vars.username} that Home Manager activation failed";
    serviceConfig.Type = "oneshot";
    path = [ pkgs.systemd pkgs.util-linux pkgs.libnotify pkgs.gnugrep pkgs.coreutils ];
    script = ''
      # The usual cause is a file Home Manager would overwrite ("... would be clobbered").
      reason=$(journalctl -u ${unit} -n 40 --no-pager -o cat | grep -m3 -E "clobbered|error" || true)
      bus=/run/user/${vars.userId-string}/bus
      # No graphical session yet (e.g. failing at boot before login): nothing to notify.
      [ -S "$bus" ] || exit 0
      runuser -u ${vars.username} -- env DBUS_SESSION_BUS_ADDRESS=unix:path=$bus \
        notify-send --urgency=critical --app-name="NixOS rebuild" \
          "Home Manager activation failed" \
          "User packages and dotfiles were not updated.''${reason:+
$reason}
Details: journalctl -u ${unit}"
    '';
  };
}
