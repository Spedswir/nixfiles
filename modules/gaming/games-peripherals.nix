{ config, pkgs, ... }:

{
    home.packages = with pkgs; [
            yarg # Yet Another Rhythm Game (Rock band clone)
    ];
}
