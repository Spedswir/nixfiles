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

    # Replaces btop's own launcher (same btop.desktop name), so the app menu entry and the
    # Ctrl+Shift+Esc shortcut open btop in a kitty window of a fixed size.
    # Size is in columns (c) and lines. remember_window_size=no is needed or kitty ignores it.
    xdg.desktopEntries.btop = {
        name = "btop++";
        genericName = "System Monitor";
        icon = "btop";
        exec = "${config.programs.kitty.package}/bin/kitty --class btop -o remember_window_size=no -o initial_window_width=160c -o initial_window_height=45c ${config.programs.btop.package}/bin/btop";
        terminal = false;
        categories = [ "System" "Monitor" ];
    };
}
