{ config, pkgs, ... }:

{
    programs = {
        gamemode.enable = true;
        gamescope.enable = true;
        gpu-screen-recorder.enable = true;
        steam = {
            enable = true;
            protontricks.enable = true;
        };
    };

    hardware = {
        xone.enable = true;
        xpad-noone.enable = true;
        graphics = {
            enable = true;
            enable32Bit = true;
        };
    };

    services.udev.packages = [ pkgs.game-devices-udev-rules ];
}
