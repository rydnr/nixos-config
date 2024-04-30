{ config, lib, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    brave
    chromium
    firefox
    #    next
    tor
    #    torbrowser
    surf
  ];
}
