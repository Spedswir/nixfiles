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
      #../../modules/nixos/proton-drive.nix
      ../../modules/nixos/de/kde.nix
      ../../modules/nixos/aus-locale.nix
      ../../modules/nixos/grub.nix
    ];

  # Enable networking
  networking = {
    hostName = "${vars.username}-laptop";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  hardware.graphics.enable = true;
  # Enable these if nvidia GPU is present
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.open = false; # False uses the proprietary driver.

  # Configuring PRIME - https://wiki.nixos.org/wiki/NVIDIA#Hybrid_graphics_with_PRIME
  hardware.nvidia.prime = {
    # intelBusId = "";
    # nvidiaBusId = "";
    # amdgpuBusId = ""; # If you have an AMD iGPU
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

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
