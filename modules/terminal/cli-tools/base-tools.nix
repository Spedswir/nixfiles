{ config, pkgs, ... }:

{
    programs = {
        fastfetch.enable = true;
        git = {
            enable = true;
            settings = {
                user = {
                    name = "Spedswir";
                    email = "spedswir@protonmail.com";
                };

                init.defaultBranch = "main";
            };
        };
    };
}
