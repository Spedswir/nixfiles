{ appimageTools, fetchurl, lib, ...}:

let
  # Lichii tags releases as build-<n>; bump this and the hash to update.
  build = "160";
  version = "build-${build}";
  pname = "lichii";
  id = "io.github.zortos293.lichii";

  src = fetchurl {
    url = "https://github.com/zortos293/Lichii/releases/download/build-${build}/lichii-linux-x86_64.AppImage";
    hash = "sha256-gJ7mp5pOvMkCIzok7hre9RaIwQ1LYczSmoPX8XVg94I=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  # Libraries the AppImage links against (or dlopens) that aren't bundled or in the default FHS env.
  extraPkgs = pkgs: with pkgs; [
    libgpg-error
    e2fsprogs # libcom_err
    libusb1
    vulkan-loader
    wayland
    libxkbcommon
    libpulseaudio
    pipewire
  ];

  # pname matches the desktop entry's Exec=lichii, so no substitution needed.
  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/${id}.desktop -t $out/share/applications
    install -Dm444 ${appimageContents}/${id}.png -t $out/share/pixmaps
  '';

  meta = {
    description = "Experimental Nintendo Switch and Switch 2 emulator (fork of Eden/yuzu)";
    homepage = "https://github.com/zortos293/Lichii";
    license = lib.licenses.gpl3Plus;
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
  };
}
