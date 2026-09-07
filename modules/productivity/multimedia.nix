{ config, pkgs, ... }:

{
    programs.freetube.enable = true;

    home.packages = [
        pkgs.feishin
        pkgs.haruna
    ];
}
