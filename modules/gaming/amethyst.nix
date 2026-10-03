{ appimageTools, fetchurl, lib, ...}:

let
  version = "1.2.1";
  pname = "AmethystModManager";
  id = "mod-manager";

  src = fetchurl {
    url = "https://github.com/ChrisDKN/Amethyst-Mod-Manager/releases/download/v${version}/${pname}-${version}-x86_64.AppImage";
    hash = "sha256-J7cLxtpJmc8W4XCTGcnDU9T33Cc836mbRnepYCNO/8I=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  # wrapType2 names the binary after pname, so point the AppImage's desktop entry at it.
  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/${id}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${id}.desktop \
      --replace-fail 'Exec=${id}' 'Exec=${pname}' \
      --replace-fail 'Name=Mod Manager' 'Name=Amethyst Mod Manager'
    install -Dm444 ${appimageContents}/${id}.png -t $out/share/pixmaps
  '';

  meta = {
    description = "A Linux native mod manager for a variety of games";
    homepage = "https://github.com/ChrisDKN/Amethyst-Mod-Manager";
    # changelog = "https://github.com/ChrisDKN/Amethyst-Mod-Manager/blob/${finalAttrs.src.rev}/Changelog.txt";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ legit228 ];
    mainProgram = pname;
    platforms = lib.platforms.linux;

  };
}
