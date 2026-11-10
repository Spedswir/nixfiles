{ config, pkgs, ... }:

{
    home.packages = with pkgs; [
        github-desktop
        parabolic # gui frontend for yt-dlp
        speedtest-cli # internet speed test via speedtest.net
    ];
}
