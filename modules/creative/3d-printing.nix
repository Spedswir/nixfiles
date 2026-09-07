{ config, pkgs, ... }:

{
    home.packages = [
        pkgs.lycheeslicer
        pkgs.prusa-slicer
    ];
}
