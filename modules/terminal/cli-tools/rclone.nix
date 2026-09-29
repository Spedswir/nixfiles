{ config, pkgs, ... }:

{
    imports = [
        ./rclone-automount.nix
    ];

    home.packages = with pkgs; [
        rclone
    ];

    myOpt.rclone.automount = {
        your-remote-a.enable = true;
        your-remote-b.enable = true;
    };
}
