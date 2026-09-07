{ config, pkgs, ... }:

{
    includes = [
        ./ides/vs-code.nix
    ];

    home.packages = [
        pkgs.godot-mono
    ];
}
