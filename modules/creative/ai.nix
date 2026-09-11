{ config, pkgs, ... }:

let
  koboldcppCuda = pkgs.writeShellScriptBin "koboldcpp" ''
    export LD_PRELOAD="/run/opengl-driver/lib/libcuda.so.1''${LD_PRELOAD:+:$LD_PRELOAD}"
    exec ${pkgs.koboldcpp}/bin/koboldcpp "$@"
  '';
in
{
    nixpkgs.config.cudaSupport = true;
    nixpkgs.config.cudaCapabilities = [ "8.9" ];

    home.packages = [
        pkgs.sillytavern
        koboldcppCuda
    ];
}
