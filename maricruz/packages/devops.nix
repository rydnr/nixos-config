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
      azure-cli
      azure-functions-core-tools
      bc
      bind
      binutils-unwrapped
      # 404    burpsuite
      brev-cli
      bustle
      # cloud-sql-proxy
      cntlm
      colordiff
      cron
      # dbeaver-bin until 24.05
      direnv
      dnsmasq
      dnsperf
      ec2-api-tools
      ec2-ami-tools
      efibootmgr
      eksctl
      elvish
      #    eternal-terminal
      ettercap
      fish
      gh
      ghostunnel
      github-runner
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
      pulumiPackages.pulumi-python
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
      # terraform
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
      # vault
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
