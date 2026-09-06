{ config, pkgs, ... }:

{
    programs = {
        steam.enable = true;
        faugus.enable = true;
        heroic-games-launcher.enable = true;
        gamemode.enable = true;
        protonplus.enable = true;
        xwaylandvideobridge.enable = true;
        gpu-screen-recorder.enable = true;

        game-devices-udev.enable = true;
        xone-dkms.enable = true;
        xpad-noone.enable = true;
    };
}
