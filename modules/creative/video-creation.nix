{ config, pkgs, ... }:

{
    home.packages = with pkgs; [
        kdePackages.kdenlive
    ];

    programs.obs-studio = {
        enable = true;

        # Nvidia hardware acceleration
        # ***** OBS's NVENC encoding generally works with the normal cached package on the proprietary driver *****
        #package = (
        #    pkgs.obs-studio.override {
        #        cudaSupport = true;
        #    }
        #);

        plugins = with pkgs.obs-studio-plugins; [
            wlrobs
            obs-pipewire-audio-capture
            obs-gstreamer
            obs-vkcapture
        ];
    };
}
