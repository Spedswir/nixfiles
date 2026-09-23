{ config, pkgs, flake-inputs, ... }:

{
    home.packages = with pkgs; [
        upscayl # local ai image upscaler
        pdfarranger
    ];
}
