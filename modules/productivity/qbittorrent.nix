{ config, pkgs, lib, ... }:

# qBittorrent, with its download and incomplete folders set by nix.
#
# qBittorrent has no Home Manager module and rewrites qBittorrent.conf itself, so the file
# can't be a read-only home.file link. Instead only the keys below are set on each switch;
# every other setting in the file is left as qBittorrent wrote it.
# qBittorrent writes its config back when it closes, so close it before rebuilding.
# The listening port is not set here: on Proton VPN it's changed by hand to the forwarded
# port, which a rebuild would otherwise reset (see modules/nixos/firewall/torrent.nix).
let
  home = config.home.homeDirectory;
  downloads = "${home}/Downloads/Torrents";
  incomplete = "${downloads}/Incomplete";
  conf = "${config.xdg.configHome}/qBittorrent/qBittorrent.conf";

  # [section] key=value pairs to set. Keys are written as they appear in the file.
  settings = [
    { section = "BitTorrent"; key = ''Session\DefaultSavePath''; value = downloads; }
    { section = "BitTorrent"; key = ''Session\TempPath''; value = incomplete; }
    { section = "BitTorrent"; key = ''Session\TempPathEnabled''; value = "true"; }
  ];

  # Sets one key in an INI file: replaces it if present, otherwise adds it at the end of its
  # section, or adds the section at the end of the file. Matching is literal (keys have "\").
  setIniKey = pkgs.writeShellScript "set-ini-key" ''
    file=$1
    # Passed through the environment, as awk -v would treat the "\" in keys as an escape.
    SEC="[$2]" KEY=$3 VAL=$4 ${pkgs.gawk}/bin/awk '
      BEGIN { sec = ENVIRON["SEC"]; key = ENVIRON["KEY"]; val = ENVIRON["VAL"] }
      function add() { print key "=" val; done = 1 }
      /^\[.*\]$/ { if (insec && !done) add(); insec = ($0 == sec); if (insec) seen = 1 }
      insec && index($0, key "=") == 1 { if (!done) add(); next }
      { print }
      END { if (!done) { if (!seen) print sec; add() } }
    ' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
  '';
in
{
  home.packages = [ pkgs.qbittorrent ];

  home.activation.qbittorrentPaths = lib.hm.dag.entryAfter [ "writeBoundary" ] (''
    run mkdir -p "${downloads}" "${incomplete}" "$(dirname "${conf}")"
    [ -f "${conf}" ] || run touch "${conf}"
  '' + lib.concatMapStrings (s: ''
    run ${setIniKey} "${conf}" ${lib.escapeShellArg s.section} ${lib.escapeShellArg s.key} ${lib.escapeShellArg s.value}
  '') settings);
}
