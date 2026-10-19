{ config, pkgs, ... }:

{
    home.packages = with pkgs; [
        krita
        (callPackage ../artcraft-apps.nix { }).photocraft
    ];
}
