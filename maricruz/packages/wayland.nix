{ config, lib, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    autotiling
    brightnessctl
    clipman
    flashfocus
    gammastep
    kanshi
    sway
    waybar
    wf-recorder
    (pkgs.writeTextFile {
      name = "startsway";
      destination = "/bin/startsway";
      executable = true;
      text = ''
        #! ${pkgs.bash}/bin/bash

        # first import environment variables from the login manager
        systemctl --user import-environment
        # then start the service
        exec systemctl --user start sway.service
      '';
    })
  ];

  programs.sway = {
    enable = false;
    wrapperFeatures.gtk = true; # so that gtk works properly
    extraPackages = with pkgs; [
      swaylock
      swayidle
      wl-clipboard
      mako # notification daemon
      alacritty # Alacritty is the default terminal in the config
      dmenu # Dmenu is the default in the config but i recommend wofi since its wayland native
      wofi
    ];
  };

  # environment = {
  #   etc = {
  #     # Put config files in /etc. Note that you also can put these in ~/.config, but then you can't manage them with NixOS anymore!
  #     "sway/config".source = ./dotfiles/sway/config;
  #     "xdg/waybar/config".source = ./dotfiles/waybar/config;
  #     "xdg/waybar/style.css".source = ./dotfiles/waybar/style.css;
  #   };
  # };

  systemd.user.targets.sway-session = {
    description = "Sway compositor session";
    documentation = [ "man:systemd.special(7)" ];
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
  };

  systemd.user.services.sway = {
    enable = false;
    description = "Sway - Wayland window manager";
    documentation = [ "man:sway(5)" ];
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
    # We explicitly unset PATH here, as we want it to be set by
    # systemctl --user import-environment in startsway
    environment.PATH = lib.mkForce null;
    serviceConfig = {
      Type = "simple";
      ExecStart = ''
        ${pkgs.dbus}/bin/dbus-run-session ${pkgs.sway}/bin/sway --debug
      '';
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  programs.waybar.enable = false;

  systemd.user.services.kanshi = {
    enable = false;
    description = "Kanshi output autoconfig ";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      # kanshi doesn't have an option to specifiy config file yet, so it looks
      # at .config/kanshi/config
      ExecStart = ''
        ${pkgs.kanshi}/bin/kanshi
      '';
      RestartSec = 5;
      Restart = "always";
    };
  };
}
