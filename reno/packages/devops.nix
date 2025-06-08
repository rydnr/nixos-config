{ config, lib, pkgs, ... }: {
  environment.systemPackages = with pkgs;
    [
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
      lshw
      lsof
      ltrace
      ngrok
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
    ] ++ lib.optionals config.myCustomFlags.dockerEnabled [
      docker
      docker-compose
      dockfmt
    ] ++ lib.optionals config.myCustomFlags.kubernetesEnabled [
      conntrack-tools
      cri-tools
      ethtool
      kompose
      kubectl
      kubernetes
      kubernetes-helm
      socat
    ] ++ lib.optionals config.myCustomFlags.virtualBoxEnabled [
      virtualbox
      linuxPackages.virtualbox
    ] ++ lib.optionals config.myCustomFlags.libvirtdEnabled [ libvirt ];
}
