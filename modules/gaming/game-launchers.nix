{ config, pkgs, osConfig, ... }:

let
    # Default audio output for launchers and their games; set via gaming.audioSink in the host's configuration.nix
    withSink = (pkgs.callPackage ./audio-sink-wrap.nix { }) (osConfig.gaming.audioSink or null);
in
{
    home.packages = with pkgs; [
        (withSink faugus-launcher)
        (withSink heroic)
        protonplus
    ];
}
