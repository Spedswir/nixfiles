{ config, pkgs, ... }:

{
    imports = [
        ./ides/vs-code.nix
    ];

    home.packages = [
        pkgs.godot-mono
    ];
}
