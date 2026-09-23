{ config, pkgs, ... }:

{
    home.packages = with pkgs; [
        parabolic # gui frontend for yt-dlp
    ];
}
