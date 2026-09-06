{ config, pkgs, ... }:

{
    programs = {
        fastfetch.enable = true;
        git = {
            enable = true;
            userName = "Spedswir";
            userEmail = "spedswir@protonmail.com";
            extraConfig = {
                init.defaultBranch = "main";
                # safe.directory = "/etc/nixos"
            };
        };
    };
}
