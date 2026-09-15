{ config, pkgs, ... }:

{
  boot.kernelModules = [ fuse ];
  security.wrappers.fuse = [ fusermount ];
  users.users.yourUser.extraGroups = [ fuse ];

  environment.systemPackages = with pkgs; [
    rclone
  ];

  # You need to manually run these commands to configure rclone
  # Choose new remote, type protondrive, follow prompts for OAuth.
  # rclone config

  # rclone ls protondrive:
  # rclone copy mnt/remote/proton protondrive:Backup
}




