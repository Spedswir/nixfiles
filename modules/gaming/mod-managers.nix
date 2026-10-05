{ config, pkgs, inputs, ... }:

{
    home.packages = with pkgs; [
        prismlauncher # Minecraft mod manager and launcher (wiki.nixos.org/wiki/Prism_Launcher)
        (callPackage ./amethyst.nix { }) # Amethyst Mod Manager
        # Space Engineers plugin loader (github.com/Avo-Catto/PulsarFlake)
        # Provides `ipulsar`, which copies Pulsar into ./Pulsar of the directory it's run from
        inputs.pulsar.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
}
