{ config, pkgs, ... }:

{
    programs = {
        yt-dlp.enable = true;
        gallery-dl.enable = true;
    };
}
