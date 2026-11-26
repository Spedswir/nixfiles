{ config, lib, pkgs, ... }:

let
    sink = config.gaming.audioSink;
in
{
    imports = [ ./firewall/steam.nix ];

    # Set per host. Home Manager's launcher modules read it through osConfig.
    options.gaming.audioSink = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "alsa_output.usb-TC-Helicon_GoXLRMini-00.HiFi__Line1__sink";
        description = ''
            PipeWire/PulseAudio sink that game launchers (Steam, Faugus, Heroic, Prism, Lichii)
            and the games they start play to by default, via PULSE_SINK. Null leaves audio alone.
            Find sink names with: pw-dump | grep '"node.name": "alsa_output'
        '';
    };

    config = {
        programs = {
            gamemode.enable = true;
            gamescope.enable = true;
            gpu-screen-recorder.enable = true;
            steam = {
                enable = true;
                protontricks.enable = true;
            } // lib.optionalAttrs (sink != null) {
                package = pkgs.steam.override { extraEnv.PULSE_SINK = sink; };
            };
        };

        hardware = {
            xone.enable = true;
            xpad-noone.enable = true;
            graphics = {
                enable = true;
                enable32Bit = true;
            };
        };

        services.udev.packages = [ pkgs.game-devices-udev-rules ];
    };
}
