{ config, pkgs, ... }:

{
    i18n.inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5 = {
            waylandFrontend = true;
            # Local config at ~/.config/fcitx5 needs to be ignored
            ignoreUserConfig = true;
            addons = with pkgs; [
                fcitx5-mozc
                fcitx5-gtk
            ];
            settings = {
                inputMethod = {
                    GroupOrder."0" = "Default";

                    "Groups/0" = {
                        Name = "Default";
                        "Default Layout" = "us";
                        DefaultIM = "keyboard-us";
                    };

                    "Groups/0/Items/0".Name = "keyboard-us";
                    "Groups/0/Items/1".Name = "mozc";
                };
                globalOptions.Behavior = {
                    ActiveByDefault = true;
                };
            };
        };
    };
}
