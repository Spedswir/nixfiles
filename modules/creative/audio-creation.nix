{ config, pkgs, ... }:

{
    home.packages = with pkgs; [
        audacity
        lmms
        (callPackage ../artcraft-apps.nix { }).soundcraft
    ];
}
