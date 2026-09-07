{ config, pkgs, ... }:

{
    includes = [
        ./audio-creation.nix
        ./programming/game-creation.nix
        ./video-creation.nix
        ./art-creation.nix
        ./3d-printing.nix
    ];
}
