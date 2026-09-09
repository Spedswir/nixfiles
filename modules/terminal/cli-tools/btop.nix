{ config, pkgs, ... }:

{
    programs.btop = {
        enable = true;
        settings = {
            color_theme = "tokyo-storm";
            theme_background = true;
            truecolor = true;
            force_tty = false;
            rounded_corners = true;
        };
    };
}
