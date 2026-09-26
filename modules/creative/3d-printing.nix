{ config, pkgs, ... }:

{
    home.packages = with pkgs; [
        lycheeslicer
        # prusa-slicer
        orca-slicer
    ];
}
