# balenaEtcher isn't in nixpkgs anymore, and 2.x releases no longer ship an AppImage,
# so this repackages the official .deb.
{ stdenv, fetchurl, lib, dpkg, autoPatchelfHook, makeWrapper, wrapGAppsHook3,
  alsa-lib, at-spi2-atk, cairo, cups, dbus, expat, gtk3, libdrm, libgbm, libGL,
  libxkbcommon, nspr, nss, pango, systemd, udev,
  libx11, libxcomposite, libxdamage, libxext, libxfixes, libxrandr, libxcb, ...}:

stdenv.mkDerivation rec {
  pname = "balena-etcher";
  version = "2.1.9";

  src = fetchurl {
    url = "https://github.com/balena-io/etcher/releases/download/v${version}/balena-etcher_${version}_amd64.deb";
    hash = "sha256-fg0OCYbl0PPZwDpMAAT5iRI1FQ4NqZ+gvDMtjAPxpMA=";
  };

  nativeBuildInputs = [ dpkg autoPatchelfHook makeWrapper wrapGAppsHook3 ];

  buildInputs = [
    alsa-lib at-spi2-atk cairo cups dbus expat gtk3 libdrm libgbm libxkbcommon
    nspr nss pango
    libx11 libxcomposite libxdamage libxext libxfixes libxrandr libxcb
  ];

  dontWrapGApps = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/lib $out/share
    cp -r usr/lib/balena-etcher $out/lib/
    cp -r usr/share/applications usr/share/pixmaps $out/share/
    runHook postInstall
  '';

  # Electron loads libudev (drive detection) and libGL at runtime, so they need to be on the path.
  postFixup = ''
    makeWrapper $out/lib/balena-etcher/balena-etcher $out/bin/balena-etcher \
      "''${gappsWrapperArgs[@]}" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ udev systemd libGL ]} \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto}}"
  '';

  meta = {
    description = "Flash OS images to SD cards and USB drives, safely and easily";
    homepage = "https://etcher.balena.io";
    license = lib.licenses.asl20;
    mainProgram = "balena-etcher";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
