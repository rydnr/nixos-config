{ config, pkgs, ... }:

{
  services.syncthing = {
    enable = true;
    user = "chous";
    dataDir = "/home/chous/.config/syncthing";
  };
}
