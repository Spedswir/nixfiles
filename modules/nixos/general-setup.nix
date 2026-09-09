{ config, pkgs, ... }:

{
    fonts = {
        enableDefaultPackages = true;
        packages = with pkgs; [
            noto-fonts
            noto-fonts-cjk
            noto-fonts-emoji
            nerdfonts
            corefonts

            # For Japanese if needed
            ipafont
            kochi-substitute
        ];
    };
    # Installs the nerd-fonts library
    # fonts.packages = [ "Jetbrains Mono" ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
}
