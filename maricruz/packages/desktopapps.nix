{ config, lib, pkgs, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    arandr
    audacity
    autocutsel
    blender
    dmenu
    dropbox
    enhanced-ctorrent
    feh
    fontconfig
    gimp
    gpicview
    gnome3.gnome-terminal
    gwenview
    inkscape
    libreoffice
    lightdm
    mcomix3
    mplayer
    pencil
    pidgin
    redshift
    rxvt_unicode-with-plugins
    screen
    scrot
    # marked as broken    synfigstudio
    stalonetray
    # shows a license    teamspeak_client
    #    tigervnc
    tmux
    tmuxinator
    wine
    xclip
    xdotool
    xfontsel
    xmacro
    xzgv
    zathura
  ];
}
