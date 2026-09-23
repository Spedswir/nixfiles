{ config, pkgs, ... }:

{
    imports = [
        ./logitech.nix
    ];

    home.packages = [
        pkgs.goxlr-utility
        pkgs.streamdeck-ui
    ];
}
