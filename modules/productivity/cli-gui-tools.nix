{ config, pkgs, ... }:

{
    home.packages = with pkgs; [
        gitkraken
        parabolic # gui frontend for yt-dlp
    ];
}
