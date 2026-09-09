{ config, pkgs, ... }:

{
    imports = [
        # ./amethyst.nix # Amethyst Mod Manager
    ];

    home.packages = with pkgs; [
        faugus-launcher
        heroic
        protonplus
        steam
    ];
}
