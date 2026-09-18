{ config, pkgs, flake-inputs, ... }:

{
    imports =
    [
      ./terminal/kitty.nix
      ./productivity/communications.nix
      ./productivity/multimedia.nix
      ./productivity/documents.nix
    ];

    # Install Brave and ensure that specific extensions are installed.
    programs.chromium = {
      enable = true;
      package = pkgs.brave;
      extensions = [
        { id = "ghmbeldphafepmbegfdlkpapadhbakde"; } # Proton Pass
        { id = "jplgfhpmjnbigmhklmmbgecoobifkmpa"; } # Proton VPN
        { id = "lkhiljgmbeecmljiogckofcalncmfnfo"; } # Migaku
      ];
      commandLineArgs = [
        "--disable-features=WebRtcAllowInputVolumeAdjustment"
      ];
    };

    home.packages = with pkgs; [
        proton-vpn
        qdirstat
        nix-search-tv
        qbittorrent
        librewolf-bin
        gnome-calculator
        pciutils # For diagnostics, includes lspci
        pdftk
    ];
}
