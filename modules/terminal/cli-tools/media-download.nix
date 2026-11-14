{ config, pkgs, ... }:

{
    programs = {
        yt-dlp = {
            enable = true;
            settings = {
                # Best video up to 1440p (falls back to 1080p, then lower), preferring mp4/m4a streams.
                format-sort = "res:1440,ext:mp4:m4a";
                # Merge the separate video and audio streams into an .mp4.
                merge-output-format = "mp4";
            };
        };
        gallery-dl.enable = true;
    };
}
