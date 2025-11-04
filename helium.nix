{ lib, stdenv, fetchurl, makeWrapper, autoPatchelfHook
, gtk3, nss, alsa-lib, xdg-utils, libXScrnSaver, cups, libgcrypt
, systemd, dbus, libpulseaudio, pciutils, libva, libffi
, mesa, libgbm, libsForQt5, qt6Packages, qt6ct }:

stdenv.mkDerivation rec {
  pname = "helium-browser";
  version = "0.6.3.1";

  src = fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64_linux.tar.xz";
    sha256 = "sha256-EYIk/0amtnHbnIWiafkvfRaVRK4A1hcqUrasseFE480=";
  };

  desktopFile = fetchurl {
    url = "https://raw.githubusercontent.com/imputnet/helium-linux/${version}/package/helium.desktop";
    sha256 = "sha256-zOhmjBjTMHelhctdllIuWgKuAXorr4APjXIUzm0F09I=";  # We'll get this hash next
  };

  nativeBuildInputs = [ makeWrapper autoPatchelfHook ];

  buildInputs = [
    gtk3 nss alsa-lib xdg-utils libXScrnSaver cups libgcrypt
    systemd dbus libpulseaudio pciutils libva libffi libgbm
    libsForQt5.qt5.qtbase qt6ct
  ];

  dontConfigure = true;
  dontBuild = true;
  dontWrapQtApps = true;

  installPhase = ''
    mkdir -p $out/opt/helium-browser
    cp -r . $out/opt/helium-browser/

    mkdir -p $out/bin
    makeWrapper $out/opt/helium-browser/chrome-wrapper $out/bin/helium-browser \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}"
    
    # Install desktop file
    mkdir -p $out/share/applications
    cp ${desktopFile} $out/share/applications/helium-browser.desktop
    
    substituteInPlace $out/share/applications/helium-browser.desktop \
      --replace "Exec=chromium" "Exec=helium-browser" \
      --replace "Name=Helium" "Name=Helium Browser" \
      --replace "Icon=helium" "Icon=helium-browser"
    
    mkdir -p $out/share/pixmaps
    mkdir -p $out/share/icons/hicolor/256x256/apps
    cp $out/opt/helium-browser/product_logo_256.png $out/share/pixmaps/helium-browser.png
    cp $out/opt/helium-browser/product_logo_256.png $out/share/icons/hicolor/256x256/apps/helium-browser.png
  '';

  meta = with lib; {
    description = "Private, fast, and honest web browser based on Chromium";
    homepage = "https://helium.computer/";
    license = licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
  };
}
