{ config, pkgs, ... }:

{
  imports =
    [
        ./kde.nix
    ];

  environment.systemPackages = [
    pkgs.kdePackages.plasma-bigscreen
  ];

  services.displayManager.sessionPackages = [
    pkgs.kdePackages.plasma-bigscreen
  ];

  services.displayManager.defaultSession = "plasma-bigscreen-wayland";
}
