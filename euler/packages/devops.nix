{ config, lib, pkgs, ... }: {
  environment.systemPackages = with pkgs;
    [
      atop
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
      wget
      which
      zip
      zlib
    ] ++ lib.optionals config.myCustomFlags.kubernetesEnabled [
      kompose
      kubectl
      kubernetes
    ];
}
