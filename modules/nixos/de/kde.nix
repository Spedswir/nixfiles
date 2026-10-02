{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    kdePackages.merkuro
    # PIM Events plugin: shows Merkuro/Akonadi calendar events in the clock widget's calendar
    kdePackages.kdepim-addons
  ];

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  security.pam.services.sddm.kwallet = {
    enable = true;
    package = pkgs.kdePackages.kwallet-pam;
  };

  # Enable KDE Connect and open its firewall ports (1714-1764 TCP/UDP)
  programs.kdeconnect.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable networking
  networking = {
    networkmanager = {
      enable = true;
    };
  };
}
