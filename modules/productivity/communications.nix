{ config, pkgs, ... }:

{
    programs.element-desktop.enable = true;
    programs.discord.enable = true;

    home.packages = with pkgs; [
        signal-desktop
    ];
}
