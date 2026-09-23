{ config, pkgs, ... }:

{
    imports = [
        # ./amethyst.nix # Amethyst Mod Manager
    ];

    home.packages = with pkgs; [
        prismlauncher # Minecraft mod manager and launcher (wiki.nixos.org/wiki/Prism_Launcher)
    ];
}
