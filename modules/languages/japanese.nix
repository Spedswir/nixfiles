{ config, pkgs, ... }:

{
    i18n.inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5 = {
            waylandFrontend = true;
            ignoreUserConfig = true; # use the below settings
            addons = with pkgs; [
                fcitx5-mozc
            ];
            settings = {
                inputMethod = {
                    "Groups/0" = {
                        Name = "Default";
                        "Default Layout" = "us";
                        DefaultIM = "keyboard-us";
                    };
                    "Groups/0/Items/0".Name = "keyboard-us";
                    "Groups/0/Items/1".Name = "mozc";
                };
            };
        };
    };
}
