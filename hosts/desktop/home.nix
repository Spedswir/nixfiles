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
    ../../modules/default-apps.nix
    ../../aliases/bash-aliases-desktop.nix
    ../../autostart/autostart-desktop.nix
    ../../modules/languages/japanese.nix
    ../../modules/terminal/cli-tools/media-download.nix
    ../../modules/gaming/game-launchers.nix
    ../../modules/gaming/mod-managers.nix
    ../../modules/gaming/games-peripherals.nix
    ../../modules/gaming/programming-games.nix
    ../../modules/hardware/desktop-hardware.nix
    ../../modules/creative/add-all-creative.nix
    ../../modules/creative/ai.nix
    ../../modules/productivity/cli-gui-tools.nix
    ../../modules/terminal/cli-tools/ansible.nix
    ../../modules/fonts.nix
    ../../modules/wallpaper-selector.nix
    ../../modules/online-accounts/protondrive.nix
  ];

  home.stateVersion = "26.05"; # Please read the comment before changing.

  home.packages = [
    # Nintendo Switch emulator (community fork of Ryujinx). Its data lives in ~/.config/Ryujinx:
    #   - prod.keys and title.keys (dumped from your Switch) go in ~/.config/Ryujinx/system/
    #   - Firmware: Tools > Install Firmware, pointed at the firmware .zip or folder (installs into bis/)
    #   - Games (.nsp/.xci) can live anywhere; add the folder under Options > Settings > General > Game Directories
    pkgs.ryubing
    (pkgs.callPackage ../../modules/gaming/ultratears.nix { }) # UltraTears, native TotK port (github.com/kuraeow/ultratears)
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
