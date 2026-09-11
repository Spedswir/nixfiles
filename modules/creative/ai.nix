{ config, pkgs, ... }:

{
    nixpkgs.config.cudaSupport = true;
    nixpkgs.config.cudaCapabilities = [ "8.9" ];

    home.packages = [
        pkgs.sillytavern
        pkgs.koboldcpp
    ];
}
