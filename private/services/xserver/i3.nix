{ config, pkgs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver = {

    windowManager = {
      i3 = {
        enable = false;
        extraPackages = with pkgs; [ dmenu i3status i3lock i3blocks ];
      };
    };
  };
}
