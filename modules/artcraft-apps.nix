# ArtCraft suite (getartcraft.com) - every app ships an AppImage from
# github.com/storytold/<app> with the same layout, so they share one builder.
# To update an app, bump its version and set hash = lib.fakeHash; the build
# error will print the real hash.
{ appimageTools, fetchurl, lib, ...}:

let
  mkArtcraftApp = { pname, version, hash, description }:
    let
      id = "ai.storyteller.${pname}";

      src = fetchurl {
        url = "https://github.com/storytold/${pname}/releases/download/v${version}/${pname}-${version}-linux-x86_64.AppImage";
        inherit hash;
      };

      appimageContents = appimageTools.extract { inherit pname version src; };
    in
    appimageTools.wrapType2 {
      inherit pname version src;

      extraInstallCommands = ''
        install -Dm444 ${appimageContents}/${id}.desktop -t $out/share/applications
        install -Dm444 ${appimageContents}/${id}.png -t $out/share/pixmaps
      '';

      meta = {
        inherit description;
        homepage = "https://getartcraft.com/apps/${pname}";
        license = lib.licenses.asl20;
        mainProgram = pname;
        platforms = [ "x86_64-linux" ];
      };
    };
in
{
  photocraft = mkArtcraftApp {
    pname = "photocraft";
    version = "0.7.0";
    hash = "sha256-h+vONrzfazHRapyiLOKfmtjbaBheTZgRiADRwt54rEI=";
    description = "Layered image editor";
  };

  filmcraft = mkArtcraftApp {
    pname = "filmcraft";
    version = "0.9.0";
    hash = "sha256-eE5M29iYLxe07IHK9TZ/0wjXChI6eqdLzNdCAhTAxEc=";
    description = "Video editor";
  };

  effectcraft = mkArtcraftApp {
    pname = "effectcraft";
    version = "0.11.1";
    hash = "sha256-Ix5g82czTX6FiR/mU8SkNKoJPCExPh7Mj+FFm2/Vg3k=";
    description = "Motion graphics and visual effects";
  };

  soundcraft = mkArtcraftApp {
    pname = "soundcraft";
    version = "0.8.0";
    hash = "sha256-nDj40aXIGPZzoX9oqVLqiXLOpKtHIFkL2345NQSGZ2g=";
    description = "Audio editor";
  };

  cadcraft = mkArtcraftApp {
    pname = "cadcraft";
    version = "0.8.0";
    hash = "sha256-JPd+NyvwcjP3JnJFi8aRNdVLyfa7Y3ntc3hwp8EVK9I=";
    description = "CAD drafting (DXF/DWG)";
  };

  wordcraft = mkArtcraftApp {
    pname = "wordcraft";
    version = "0.8.0";
    hash = "sha256-ffezpQFyug7ehaLEuDw2CvkrHDdnyLMMOWPr8F02q5w=";
    description = "Word processor";
  };

  gridcraft = mkArtcraftApp {
    pname = "gridcraft";
    version = "0.8.0";
    hash = "sha256-lCCWoppTSqJQPp56oYFulS9yUOc9VfjzKv0HdUdhf3c=";
    description = "Spreadsheet editor";
  };
}
