{ config, pkgs, ... }:

# L2TP/IPsec VPN support for NetworkManager (e.g. "Westate VPN", a Windows RRAS server).
# The connection itself is defined in NetworkManager (KDE network settings), not here.
let
  # L2TP/IPsec uses IKEv1, which strongSwan 6.x leaves out of its default build
  # ("IKE version 1 not supported"). Build it back in, just for the L2TP plugin.
  strongswanIkev1 = pkgs.strongswan.overrideAttrs (old: {
    configureFlags = old.configureFlags ++ [ "--enable-ikev1" ];
  });
in
{
  networking.networkmanager.plugins = [
    (pkgs.networkmanager-l2tp.override { strongswan = strongswanIkev1; })
  ];

  # networkmanager-l2tp starts its own strongSwan (charon) for the IPsec layer, so the
  # strongswan system service isn't wanted (the plugin just stops it). Its charon reads
  # /etc/strongswan.conf and aborts if it is missing; an empty file means defaults, which
  # read the PSK via /etc/ipsec.secrets (written by the NixOS networkmanager module).
  environment.etc."strongswan.conf".text = "";

  # The plugin writes the PSK to /etc/ipsec.d/ipsec.nm-l2tp.secrets but won't create the
  # directory itself ("Could not write /etc/ipsec.d/ipsec.nm-l2tp.secrets").
  # The NixOS networkmanager module already adds the include line to /etc/ipsec.secrets.
  systemd.tmpfiles.rules = [ "d /etc/ipsec.d 0700 root root -" ];
}
