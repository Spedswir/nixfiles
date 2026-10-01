{ config, pkgs, ... }:

{
    i18n.inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5 = {
            waylandFrontend = true;
            # Must stay false under home-manager: `settings` below are written to
            # ~/.config/fcitx5, which ignoreUserConfig (SKIP_FCITX_USER_PATH) hides
            # from fcitx5, leaving only the keyboard-us fallback group.
            ignoreUserConfig = false;
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
                globalOptions = {
                    Behavior = {
                        # New windows start on keyboard-us instead of mozc
                        ActiveByDefault = false;
                    };
                    # Super+Space toggles between keyboard-us and mozc
                    "Hotkey/TriggerKeys" = {
                        "0" = "Super+space";
                    };
                };
            };
        };
    };
}
