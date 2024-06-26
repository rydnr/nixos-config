{ config, lib, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    afuse
    atop
    awscli
    bc
    binutils-unwrapped
    busybox
    cron
    direnv
    file
    glibc
    hdparm
    hwdata
    inetutils
    iotop
    isync
    jq
    keychain
    kubernetes
    lshw
    lsof
    ltrace
    p7zip
    parted
    pciutils
    pinentry
    psmisc
    sysstat
    tmux
    tree
    unzip
    usbutils
    watchman
    wget
    which
    zip
    zlib
  ];
}
