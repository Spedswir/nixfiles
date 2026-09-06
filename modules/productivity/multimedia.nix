{ config, pkgs, ... }:

{
    programs.freetube.enable = true;
    programs.brave-bin.enable = true;

    home.packages = [
        pkgs.feishin
        pkgs.haruna
    ];
}
