{ config, pkgs, ... }:

let
  vars = import ../../modules/vars.nix;
in
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."${vars.username}" = {
    uid = vars.userId;
    # gid = vars.groupId;
    isNormalUser = true;
    description = "Spedswir";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.kitty;
    packages = with pkgs; [
      kdePackages.kate
    ];
  };
}




