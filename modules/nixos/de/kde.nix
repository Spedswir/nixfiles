{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    kdePackages.merkuro
    # PIM Events plugin: shows Merkuro/Akonadi calendar events in the clock widget's calendar
    kdePackages.kdepim-addons
    # Akonadi serializer for calendar items; without it in the system profile,
    # plasmashell can't decode events ("Item N has no payload") and the widget stays empty
    kdePackages.akonadi-calendar
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

  # baloo_file can start before Plasma exports WAYLAND_DISPLAY/DISPLAY to the user
  # manager; its extractor then aborts on Qt platform init and respawns in a crash loop.
  # The indexer needs no display, so force the headless platform plugin.
  # asDropin: the unit ships with Plasma, so only override it rather than replace it.
  systemd.user.services.kde-baloo = {
    overrideStrategy = "asDropin";
    environment.QT_QPA_PLATFORM = "offscreen";
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
