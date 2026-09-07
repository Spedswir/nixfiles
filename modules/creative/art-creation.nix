{ config, pkgs, ... }:

{
    home.packages = [
        pkgs.gimp
        pkgs.krita
    ];
}
