# Apps to start at login on the desktop.
# Background helpers (Solaar, GoXLR) autostart from their own hardware modules instead.
# This uses Home Manager module syntax.
{ config, pkgs, ... }:

{
  xdg.autostart = {
    enable = true;
    entries = [
      "${pkgs.proton-vpn}/share/applications/proton.vpn.app.gtk.desktop"
      "${config.programs.element-desktop.package}/share/applications/element-desktop.desktop"
    ];
  };
}
