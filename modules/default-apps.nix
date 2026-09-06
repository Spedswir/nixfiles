{ config, pkgs, ... }:

{
    imports =
    [ # Include the results of the hardware scan.
      ./terminals/kitty.nix
      ./productivity/communications.nix
      ./productivity/multimedia.nix
    ];
}
