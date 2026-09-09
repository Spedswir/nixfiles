{ config, pkgs, ... }:

{
    programs.onlyoffice.enable = true;

    # Settings come from wiki.nixos.org/wiki/Obsidian
    programs.obsidian = {
        enable = true;
        defaultSettings = {
            app = {
                alwaysUpdateLinks = true;
                spellcheck = true;
            };
            corePlugins = [
                {
                    name = "templates";
                    settings.folder = "Templates";
                }
            ];
            communityPlugins = with pkgs.obsidianPlugins; [
                excalibrain
                zoom-map
                chronos
                kanban-bases-view
                awesome-format-bar
                pf2e-statblocks
            ];
        };
    };
}
