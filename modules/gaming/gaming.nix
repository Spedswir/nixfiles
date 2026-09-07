{ config, pkgs, ... }:

{
    home.packages = [
        pkgs.faugus-launcher
        pkgs.heroic
        pkgs.protonplus
        pkgs.steam
    ];
}
