{ config, pkgs, ... }:

{
    home.packages = with pkgs; [
        faugus-launcher
        heroic
        protonplus
    ];
}
