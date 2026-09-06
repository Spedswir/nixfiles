{ config, pkgs, ... }:

let
  vars = import ../../modules/vars.nix;
in
{
  imports = [
      ./cli-tools/btop.nix
      ./cli-tools/base-tools.nix
  ];

  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = 0.9;
      background_blur = 25;
      background_image = "${vars.homeDir}/kitty.jpg";
      background_tint = 0.3;
    };
  };
}
