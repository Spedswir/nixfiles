{ config, pkgs, inputs, osConfig, ... }:

let
    # Default audio output; set via gaming.audioSink in the host's configuration.nix
    withSink = (pkgs.callPackage ./audio-sink-wrap.nix { }) (osConfig.gaming.audioSink or null);
in
{
    home.packages = with pkgs; [
        (withSink prismlauncher) # Minecraft mod manager and launcher (wiki.nixos.org/wiki/Prism_Launcher)
        (callPackage ./amethyst.nix { }) # Amethyst Mod Manager
        # Space Engineers plugin loader (github.com/Avo-Catto/PulsarFlake)
        # Provides `ipulsar`, which copies Pulsar into ./Pulsar of the directory it's run from
        inputs.pulsar.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
}
