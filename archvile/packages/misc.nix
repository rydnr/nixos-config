{ config, lib, pkgs, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    afuse
    alsa-plugins
    alsa-plugins-wrapper
    anki
    #    autofs5
    autossh
    bc
    # bluez
    bluez-tools
    busybox
    cachix
    cifs-utils
    conky
    cowsay
    dash
    davfs2
    dmidecode
    dpkg
    # extraterm
    exfat
    fasd
    file
    ffmpeg-full
    fortune
    fzf
    gettext
    gphoto2
    glibc
    #    go-mtpfs
    google-drive-ocamlfuse
    googler
    home-manager
    i3
    i3lock
    i3minator
    i3status
    inxi
    jack2
    imagemagick
    lame
    ledger
    libselinux
    libsepol
    lsdvd
    maildrop
    # megasync
    mkvtoolnix
    mu
    newt
    # nixfmt-rfc-style until 24.05
    noisetorch
    nzbget
    p7zip
    paprefs
    par2cmdline
    patchelfUnstable
    pavucontrol
    psmisc
    pulseaudioFull
    # python3Packages.youtube-dl #insecure
    qjackctl
    ranger
    sabnzbd
    sharutils
    simplescreenrecorder
    sn0int
    stalonetray
    synergy
    #    taffybar
    # transcode
    unrar
    v4l-utils
    vlc
    vokoscreen
    vsftpd
    wpa_supplicant
    xcalib
    xclip
    xorg.xdpyinfo
    xorg.xkbcomp
    xsel
    zlib
  ];
}
