{ config, pkgs, ... }:

let
  vars = import ../../modules/vars.nix;
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "${vars.username}";
  home.homeDirectory = "/home/${vars.username}";

  # Install unfree packages
  nixpkgs.config.allowUnfree = true;

  imports = [
      ../../aliases/bash-aliases-general.nix
      ../../modules/terminal/cli-tools/media-download.nix
      ../../modules/gaming/game-launchers.nix
      ../../modules/productivity/bigscreen-apps.nix
      ../../modules/productivity/multimedia.nix
      ../../modules/fonts.nix
      ../../modules/wallpaper-selector.nix
  ];

  programs.onlyoffice.enable = true;

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
