{ config, lib, pkgs, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment = {
    systemPackages = with pkgs; [
      dunst
      fontconfig
      glxinfo
      guvcview
      hicolor-icon-theme # icons for thunar
      i3
      inotify-tools
      lxappearance
      remmina
      screen
      shared-mime-info
      simplescreenrecorder
      uvccapture
      tilda
      tmux
      tmuxinator
      xcompmgr
      xclip
      # xfce
      #     xfce.exo
      #     xfce.gtk_xfce_engine
      #     xfce.gvfs            # auto mounting
      #     xfce.libxfce4ui
      #     xfce.libxfcegui4
      #     xfce.thunar          # file manager
      #     xfce.thunar_volman   # auto mounting
      #     xfce.xfce4icontheme  # for thunar
      #     xfce.xfce4settings
      #     xfce.xfconf
      xorg.xbacklight
      xorg.xev
      xorg.xeyes
      #     xorg.xf86videonvidia
      xorg.xhost
      xorg.xinit
      xorg.xkill
      xorg.xmessage
      xorg.xmodmap
    ];

    # /var/run/current-system/sw/etc/profile
    shellInit = ''
            # ===================================
            # SYSTEM WIDE CONFIGURATION GOES HERE
            # ===================================
            # Set GTK_PATH so that GTK+ can find the Xfce theme engine.
            #export GTK_PATH=$ {pkgs.xfce.gtk_xfce_engine}/lib/gtk-2.0

            # Set GTK_DATA_PREFIX so that GTK+ can find the Xfce themes.
            export GTK_DATA_PREFIX=${config.system.path}
            export XCURSOR_PATH="${config.system.path}/share/icons:$HOME/.icons:$HOME/.nix-profile/share/icons/"
            # Launch xfce settings daemon.
      #      xfsettingsd &
            # ===================================
    '';

    pathsToLink = [
      "/share/xfce4"
      "/share/themes"
      "/share/mime"
      "/share/desktop-directories"
    ];
  };
}
