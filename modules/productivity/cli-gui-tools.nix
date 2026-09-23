{ config, pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
        github-desktop
        parabolic # gui frontend for yt-dlp
    ];
}
