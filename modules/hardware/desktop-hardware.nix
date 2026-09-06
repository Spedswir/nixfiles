{ config, pkgs, ... }:

{
    programs = {
        solaar.enable = true;
        streamdeck-ui.enable = true;
        goxlr-utility.enable = true;
    };
}
