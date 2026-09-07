{ config, pkgs, ... }:

{
    imports = [
        ./audio-creation.nix
        ./programming/game-creation.nix
        ./video-creation.nix
        ./art-creation.nix
        ./3d-printing.nix
    ];
}
