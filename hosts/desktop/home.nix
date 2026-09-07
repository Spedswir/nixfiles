{ config, pkgs, ... }:

let
  vars = import ../../modules/vars.nix;
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "${vars.username}";
  home.homeDirectory = "${vars.homeDir}";

  # Install unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = (_: true);

  imports = [
    ../../modules/default-apps.nix
    ../../aliases/bash-aliases-desktop.nix
    ../../modules/languages/japanese.nix
    ../../modules/terminal/cli-tools/media-download.nix
    ../../modules/gaming/gaming.nix
    ../../modules/hardware/desktop-hardware.nix
  ];

  home.stateVersion = "26.05"; # Please read the comment before changing.

  home.packages = [
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

}
