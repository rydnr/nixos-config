{ config, lib, pkgs, ... }:
{
  hardware.bluetooth.enable = true;

  environment.systemPackages = with pkgs; [
    bluez
    pavucontrol
    pulseaudioFull
  ];
}
