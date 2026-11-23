# MEGA cloud storage desktop client (MEGAsync). Sign in and pick sync folders from its tray app.
# This uses Home Manager module syntax.
{ pkgs, ... }:

{
  home.packages = [ pkgs.megasync ];
}
