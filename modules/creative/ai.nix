{ config, pkgs, ... }:

{
    home.packages = [
        pkgs.sillytavern
        pkgs.koboldcpp
    ];
}
