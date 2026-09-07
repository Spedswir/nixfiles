{ config, pkgs, ... }:

{
    home.packages = [
        pkgs.kdePackages.kdenlive
    ];

    programs.obs-studio = {
        enable = true;

        # Nvidia hardware acceleration
        package = (
            pkgs.obs-studio.override {
                cudaSupport = true;
            }
        );

        plugins = with pkgs.obs-studio-plugins; [
            wlrobs
            obs-backgroundremoval
            obs-pipewire-audio-capture
            obs-gstreamer
            obs-vkcapture
        ];
    };
}
