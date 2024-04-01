{ config, lib, pkgs, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    #    electricsheep
    physlock
    #    rss-glx
    slock
    vlock
    xlockmore
    xautolock
    xscreensaver
    xss-lock
  ];
}
