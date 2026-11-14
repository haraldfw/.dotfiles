{ pkgs, ... }:
let
  pname = "wowup";
  version = "2.25.4";

  src = pkgs.fetchurl {
    url = "https://github.com/WowUp/WowUp/releases/download/v${version}/WowUp-${version}.AppImage";
    hash = "sha256-vSHn7R8A0teLyu70GnoHRXJD5ZA0cZDKkh1sc0T7SH0=";
  };

  appimageContents = pkgs.appimageTools.extract { inherit pname version src; };

  wowup = pkgs.appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
      install -Dm444 ${appimageContents}/wowup.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/wowup.desktop \
        --replace-fail 'Exec=AppRun' 'Exec=${pname}'
      cp -r ${appimageContents}/usr/share/icons $out/share
    '';
  };
in
{
  home.packages = [ wowup ];
}
