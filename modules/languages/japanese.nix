{ config, pkgs, ... }:

{
    i18n.inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5 = {
            waylandFrontend = true;
            ignoreUserConfig = true; # use the below settings
            addons = with pkgs; [
                fcitx5-mozc-ut
                fcitx5-gtk
            ];
            settings = {
                inputMethod = {
                    "Groups/0" = {
                        Name = "Default";
                        "Default Layout" = "au";
                        DefaultIM = "keyboard-au";
                    };
                    "Groups/0/Items/0".Name = "keyboard-au";
                    "Groups/0/Items/1".Name = "mozc";
                };
            };
        };
    };
}
