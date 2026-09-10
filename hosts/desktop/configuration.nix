{ config, pkgs, inputs, ... }:

let
  vars = import ../../modules/vars.nix;
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ../../modules/nixos/network-drives.nix
    ../../modules/nixos/users.nix
    ../../modules/nixos/gaming.nix
    ../../modules/nixos/bluetooth.nix
  ];

  # Add second driver
  fileSystems."/mnt/second_drive" = {
    device = "/dev/disk/by-uuid/639776cb-783c-4df6-aef8-7f76719380f0";
    fsType = "btrfs";
    options = ["rw"];
  };

  services.hardware.openlinkhub.enable = true;
    
  # Use the GRUB 2 boot loader.
  boot.loader = {
      systemd-boot.enable = false;
      grub = {
          enable = true;
          efiSupport = true;
          device = "nodev";
          useOSProber = true;
          # Use provided UUIDs instead of blkid probing (required for btrfs subvolumes)
          fsIdentifier = "provided";
      };

      efi.canTouchEfiVariables = true;
  };

  # Enable networking
  networking.networkmanager.enable = true;
  networking.hostName = "${vars.username}-desktop-vm"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.timeZone = "Australia/Perth";

  i18n.defaultLocale = "en_AU.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  security.pam.services.sddm.enableKwallet = true;

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  programs.steam.enable = true;

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

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  services.displayManager = {
    autoLogin.enable = true;
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
