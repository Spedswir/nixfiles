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

    # open ports for steam stream and some games
    networking.firewall = {
        allowedTCPPorts = with pkgs.lib; [ 27036 27037 ] ++ (range 27015 27030);
        allowedUDPPorts = with pkgs.lib; [ 4380 27036 ] ++ (range 27000 27031);
        allowPing = true;
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
