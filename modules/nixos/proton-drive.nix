{ config, pkgs, secrets, ... }:

{
  # Added as a flake via https://github.com/tommasie/nix-proton-drive-cli

  environment.systemPackages = with pkgs; [
    proton-drive.packages.x86_64-linux.default
  ];
}




