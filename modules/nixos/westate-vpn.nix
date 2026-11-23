{ ... }:

# "Westate VPN": L2TP/IPsec to Westate's Windows (RRAS) server. Needs ./l2tp-vpn.nix.
# The password and pre-shared key are not stored here: the *-flags = 1 settings make
# NetworkManager ask the desktop secret agent, so they live in KWallet. The UUID is kept
# the same as the original hand-made connection so the saved KWallet secrets still match.
{
  networking.networkmanager.ensureProfiles.profiles."Westate VPN" = {
    connection = {
      id = "Westate VPN";
      uuid = "3c669a45-9d45-4d67-8b74-41aed086319e";
      type = "vpn";
      autoconnect = false;
    };

    vpn = {
      service-type = "org.freedesktop.NetworkManager.l2tp";
      gateway = "103.89.81.72";
      user = "michaelr";
      ipsec-enabled = "yes";
      machine-auth-type = "psk";
      ipsec-psk-flags = "1";
      password-flags = "1";
      ephemeral-port = "no";
      # Windows RRAS only offers older IKEv1 proposals (server picked AES256/SHA1/MODP2048).
      # Dash-joined lists, as nmcli can't take commas inside vpn.data values.
      ipsec-ike = "aes256-aes128-3des-sha1-modp2048-modp1024";
      ipsec-esp = "aes256-aes128-3des-sha1";
    };

    # Split tunnel: only office traffic goes over the VPN. Routing everything through it
    # broke already-open connections when it came up. 192.168.0.0/16 covers the office
    # DNS (192.168.0.1) and the client pool (192.168.2.x); narrow it if the office range is known.
    ipv4 = {
      method = "auto";
      never-default = true;
      route1 = "192.168.0.0/16";
    };

    ipv6.method = "auto";
  };
}
