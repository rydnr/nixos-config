{ config, lib, pkgs, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    brave
    chromium
    firefox
    firefox-devedition-bin
    google-chrome
    gnome2.GConf
    gnome3.gnome-tweaks
    gnome3.nautilus
    #    next
    tor
    #    torbrowser
    surf
  ];
}
