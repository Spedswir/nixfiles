{ config, pkgs, lib, ... }:

# Remmina profile for "Westate Dev" (RDP via the Westate VPN, see modules/nixos/westate-vpn.nix).
#
# The password is not stored here. "password=." tells Remmina it is in the keyring (KWallet);
# the keyring entry is keyed by this filename, so keep the name the same. On a new machine
# Remmina asks for it on first connect.
#
# Remmina writes back to its profile files (window size, edits in the GUI), so a read-only
# home.file symlink would break saving. Instead a writable copy is installed on each switch.
# GUI changes to this profile last until the next rebuild; make lasting ones here.
# Unlisted settings use Remmina's defaults.
let
  profile = pkgs.writeText "westate-dev.remmina" ''
    [remmina]
    name=Westate Dev
    protocol=RDP
    server=192.168.0.44
    username=ATB Development
    domain=
    password=.
    colordepth=99
    resolution_mode=2
    viewmode=1
    window_width=807
    window_height=519
    window_maximize=0
    quality=0
    network=none
    sound=off
    cert_ignore=0
    ignore-tls-errors=1
    disableclipboard=0
    disablepasswordstoring=0
    gwtransp=http
  '';
  target = "${config.xdg.dataHome}/remmina/group_rdp_westate-dev_192-168-0-44.remmina";
  pref = "${config.xdg.configHome}/remmina/remmina.pref";
in
{
  home.activation.remminaWestateDev = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run install -D -m 600 ${profile} "${target}"
  '';

  # Dark UI by default. remmina.pref is Remmina's own (it holds the generated "secret" used to
  # encrypt stored passwords), so only the dark_theme key is set; nothing else is touched.
  home.activation.remminaDarkTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -f "${pref}" ]; then
      run install -D -m 644 /dev/null "${pref}"
      run sh -c 'printf "[remmina_pref]\ndark_theme=true\n" > "${pref}"'
    elif grep -q '^dark_theme=' "${pref}"; then
      run sed -i 's/^dark_theme=.*/dark_theme=true/' "${pref}"
    else
      run sed -i '/^\[remmina_pref\]/a dark_theme=true' "${pref}"
    fi
  '';
}
