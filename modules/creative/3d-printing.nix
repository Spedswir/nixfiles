{ config, pkgs, ... }:

{
    home.packages = with pkgs; [
        lycheeslicer
        # prusa-slicer
        # WebKitGTK's DMABUF renderer crashes on NVIDIA + Wayland (Error 71 Protocol error)
        (symlinkJoin {
            name = "orca-slicer";
            paths = [ orca-slicer ];
            nativeBuildInputs = [ makeWrapper ];
            postBuild = ''
                wrapProgram $out/bin/orca-slicer \
                    --set WEBKIT_DISABLE_DMABUF_RENDERER 1
            '';
        })
        (callPackage ../artcraft-apps.nix { }).cadcraft
    ];
}
