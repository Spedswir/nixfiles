{ config, pkgs, ... }:

{
    programs.freetube.enable = true;

    home.packages = with pkgs; [
        feishin
        haruna
        picard
    ];
}
