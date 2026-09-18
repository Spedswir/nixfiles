{ config, pkgs, ... }:

{
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
}
