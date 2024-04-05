{ config, pkgs, ... }:

{
  config.virtualisation.virtualbox = {
    host = {
      enable = true;
      enableHardening = false;
      addNetworkInterface = true;
      enableExtensionPack = false;
    };
    guest = {
      enable = true;
      x11 = true;
    };
  };
}
