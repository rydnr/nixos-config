{ config, pkgs, ... }:

{
  config.virtualisation.libvirtd = {
    enable = true;
  };
}
