{ config, pkgs, ... }:

{
  imports = [
      ./cli-tools/btop.nix
      ./cli-tools/base-tools.nix
  ];

  programs.kitty.enable = true;
}
