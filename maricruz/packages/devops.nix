{ config, lib, pkgs, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs;
    [
      alacritty
      atop
      aircrack-ng
      #    anydesk
      arping
      arpoison
      awscli
      #    aws_shell
      #    aws-sam-cli
      bc
      bind
      binutils-unwrapped
      # 404    burpsuite
      brev-cli
      bustle
      cloud-sql-proxy
      cntlm
      colordiff
      cron
      dbeaver
      direnv
      dnsmasq
      dnsperf
      ec2_api_tools
      ec2_ami_tools
      efibootmgr
      eksctl
      elvish
      #    eternal-terminal
      ettercap
      fish
      ghostunnel
      gnupg
      google-cloud-sdk
      google-cloud-sdk-gce
      google-compute-engine
      grpcurl
      hdparm
      hwdata
      inetutils
      inotify-tools
      iotop
      isync
      junkie
      keychain
      kind
      libguestfs
      lshw
      lsof
      ltrace
      mailutils
      mcron
      mutt
      ngrok
      nix-index
      nmap
      nox
      openconnect
      opendkim
      openfortivpn
      openshift
      openvpn
      packer
      parted
      pciutils
      pinentry
      pkg-config
      #    postfix
      postgresql
      # postman
      qemu
      redis
      robo3t
      rsnapshot
      s3fs
      screen
      socat
      sshfs
      starship
      sysstat
      tcpdump
      terraform
      thc-hydra
      #    tilix
      tmux
      tmuxinator
      tree
      #    unarj
      unetbootin
      unzip
      usbimager
      usbutils
      vagrant
      vault
      virt-manager
      watchman
      wget
      which
      wireshark
      zip
      zlib
    ] ++ lib.optionals config.myCustomFlags.dockerEnabled [
      docker
      docker-compose
      docker-machine
      dockfmt
    ] ++ lib.optionals config.myCustomFlags.kubernetesEnabled [
      kompose
      kubectl
      kubernetes
      kubernetes-helm
      minikube
    ] ++ lib.optionals config.myCustomFlags.virtualBoxEnabled [
      virtualbox
      linuxPackages.virtualbox
    ] ++ lib.optionals config.myCustomFlags.libvirtdEnabled [ libvirt ];
}
