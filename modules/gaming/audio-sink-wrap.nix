# Wraps every binary in a package so audio from it, and anything it launches, defaults to `sink`.
# PULSE_SINK is inherited by child processes, so wrapping a launcher covers its games too.
# Uses --set-default, so a per-game PULSE_SINK (e.g. in Steam launch options) still wins.
# Usage: (pkgs.callPackage ./audio-sink-wrap.nix { }) sink pkg   (sink = null returns pkg unchanged)
{ lib, symlinkJoin, makeWrapper }:

sink: pkg:
if sink == null then pkg else
symlinkJoin {
  inherit (pkg) name;
  paths = [ pkg ];
  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    for bin in $out/bin/*; do
      wrapProgram "$bin" --set-default PULSE_SINK ${lib.escapeShellArg sink}
    done
  '';
  meta = pkg.meta or { };
  passthru = pkg.passthru or { };
}
