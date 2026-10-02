# Apps to start at login on the laptop.
# Background helpers (Solaar) autostart from their own hardware modules instead.
# This uses Home Manager module syntax.
{ config, pkgs, ... }:

{
  xdg.autostart = {
    enable = true;
    entries = [
      "${pkgs.proton-vpn}/share/applications/proton.vpn.app.gtk.desktop"
    ];
  };
}
