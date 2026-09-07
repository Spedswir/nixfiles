{ config, pkgs, ... }:

{
    home.packages = [
        pkgs.goxlr-utility
        pkgs.solaar
        pkgs.streamdeck-ui
    ];
}
