{ config, pkgs, lib, ... }:

let
  # Nortantis fantasy map generator. Upstream only ships a jpackage .deb from
  # jandjheydorn.com/download-nortantis (no GitHub releases), so take the jar
  # out of it and run it on nixpkgs' JDK instead of the bundled runtime.
  # Built for Java 25 (see lib/runtime/release in the .deb).
  nortantis = pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "nortantis";
    version = "3.21";

    src = pkgs.fetchurl {
      url = "https://d2qy47ls9df5zf.cloudfront.net/nortantis_${finalAttrs.version}_amd64.deb";
      hash = "sha256-jSE87KaxOJI/2iyCXcY7oKYIzvqnUvm/pfv9Q8q2pV0=";
    };

    nativeBuildInputs = with pkgs; [ dpkg makeWrapper copyDesktopItems ];

    unpackPhase = ''
      dpkg-deb -x $src .
    '';

    # Java options and main class come from the .deb's lib/app/Nortantis.cfg.
    installPhase = ''
      runHook preInstall

      install -Dm444 opt/nortantis/lib/app/Nortantis.jar -t $out/share/nortantis
      makeWrapper ${pkgs.jdk25}/bin/java $out/bin/nortantis \
        --add-flags "-Djpackage.app-version=${finalAttrs.version}" \
        --add-flags "-XX:MaxRAMPercentage=50.0 -XX:MaxHeapFreeRatio=40 -XX:MinHeapFreeRatio=20 -XX:G1PeriodicGCInterval=15000" \
        --add-flags "-Dfile.encoding=UTF-8" \
        --add-flags "-cp $out/share/nortantis/Nortantis.jar nortantis.swing.MainWindow"

      install -Dm444 opt/nortantis/lib/Nortantis.png $out/share/pixmaps/nortantis.png
      install -Dm444 opt/nortantis/lib/application-x-nortantis.png $out/share/icons/hicolor/256x256/mimetypes/application-x-nortantis.png
      install -Dm444 opt/nortantis/lib/nortantis-Nortantis-MimeInfo.xml $out/share/mime/packages/nortantis.xml

      runHook postInstall
    '';

    desktopItems = [
      (pkgs.makeDesktopItem {
        name = "nortantis";
        desktopName = "Nortantis";
        comment = "Fantasy map generator and editor";
        exec = "nortantis %f";
        icon = "nortantis";
        startupWMClass = "nortantis-swing-MainWindow";
        categories = [ "Graphics" ];
        mimeTypes = [ "application/x-nortantis" ];
      })
    ];

    meta = {
      description = "Fantasy map generator and editor";
      homepage = "https://github.com/jeheydorn/nortantis";
      license = lib.licenses.agpl3Only;
      mainProgram = "nortantis";
      platforms = [ "x86_64-linux" ];
    };
  });
in
{
    home.packages = [
        nortantis
    ];
}
