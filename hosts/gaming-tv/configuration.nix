{ config, pkgs, inputs, ... }:

let
  vars = import ../../modules/vars.nix;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/nixos/network-drives.nix
      ../../modules/nixos/users.nix
      ../../modules/nixos/gaming.nix
      ../../modules/nixos/bluetooth.nix
      ../../modules/nixos/de/kde-bigscreen.nix
      ../../modules/nixos/aus-locale.nix
      ../../modules/nixos/grub.nix
    ];

  networking = {
    hostName = "${vars.username}-tv";
  };


  # Work around MediaTek MT7921/MT7922 PCIe power-management issues.
  boot.extraModprobeConfig = ''
    options mt7921e disable_aspm=1
  '';

  nix.settings = {
    max-jobs = 2;
    cores = 2;
    experimental-features = [ "nix-command" "flakes" ];
  };

  # Enable these if nvidia GPU is present
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.open = false; # False uses the proprietary driver.

  hardware.logitech.wireless.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "au";
    variant = "";
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  services.displayManager = {
    autoLogin.enable = false;
    autoLogin.user = "${vars.username}";
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "${vars.username}" = import ./home.nix;
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [

  ];

  # ===== DON'T CHANGE =====
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion.
  system.stateVersion = "26.05"; # Did you read the comment?
  # ========================

}
