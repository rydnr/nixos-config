{ config, pkgs, ... }:

{
  config.virtualisation.libvirtd = {
    enable = config.myCustomFlags.libvirtdEnabled;
  };
}
