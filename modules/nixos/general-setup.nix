{ config, pkgs, ... }:

{
    # Installs the nerd-fonts library
    fonts.packages = [ "Jetbrains Mono" ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
}
