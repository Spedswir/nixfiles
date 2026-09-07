{ config, pkgs, ... }:

{
    programs = {
        gamemode.enable = true;
        gamescope.enable = true;
        gpu-screen-recorder.enable = true;
    };

    hardware.xone.enable = true;
    hardware.xpad-noone.enable = true;

    services.udev.packages = [ pkgs.game-devices-udev-rules ];
}
