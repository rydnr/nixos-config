{ config, lib, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    discord
    element-desktop
    element-web
    jitsi
    #    skypeforlinux
    obs-studio
    slack
    slack-cli
    zoom-us
  ];
}
