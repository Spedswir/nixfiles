{ config, pkgs, ... }:

{
    # Programming games whose code is written and managed outside the game (e.g. in VS Code).
    imports = [
        ./programming-games/screeps.nix
    ];
}
