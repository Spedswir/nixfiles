{ appimageTools, fetchurl, lib, ...}:

let
  version = "0.2.0";
  pname = "UltraTears";
  id = "ultratears";

  src = fetchurl {
    url = "https://github.com/kuraeow/ultratears/releases/download/v${version}/${pname}.AppImage";
    hash = "sha256-2kkqr4va+HNvYWJcK8Oyg7kWlXDMA4Q6Q29J65SrUOM=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  # wrapType2 names the binary after pname, so point the AppImage's desktop entry at it.
  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/${id}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${id}.desktop \
      --replace-fail 'Exec=${id}-launcher' 'Exec=${pname}'
    install -Dm444 ${appimageContents}/${id}.png -t $out/share/pixmaps
  '';

  meta = {
    description = "Unofficial native port of Tears of the Kingdom built from your own game dump";
    homepage = "https://github.com/kuraeow/ultratears";
    license = lib.licenses.gpl3Only;
    mainProgram = pname;
    platforms = lib.platforms.linux;
  };
}
