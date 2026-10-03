{ config, pkgs, ... }:

{
    home.packages = with pkgs; [
        prismlauncher # Minecraft mod manager and launcher (wiki.nixos.org/wiki/Prism_Launcher)
        (callPackage ./amethyst.nix { }) # Amethyst Mod Manager
    ];
}
