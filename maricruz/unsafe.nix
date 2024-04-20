{ config, lib, pkgs, ... }: {
  nixpkgs.config.permittedInsecurePackages = [
    "electron-14.2.9"
    "electron-12.2.3"
    "python2.7-Pillow-6.2.2"
    "qtwebkit-5.212.0-alpha4"
  ];
}
