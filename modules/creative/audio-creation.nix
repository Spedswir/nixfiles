{ config, pkgs, ... }:

{
    home.packages = [
        pkgs.audacity
        pkgs.lmms
    ];
}
