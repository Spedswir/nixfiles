{ config, pkgs, ... }:

{
    home.packages = with pkgs; [
        github-desktop
        parabolic # gui frontend for yt-dlp
    ];
}
