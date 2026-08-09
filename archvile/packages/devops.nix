{ config, lib, pkgs, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs;
    [
      act
      age
      alacritty
      atop
      aircrack-ng
      #    anydesk
      argocd
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
      brev-cli
      bubblewrap
      burpsuite
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
      glab
      gnupg
      google-cloud-sdk
      google-cloud-sdk-gce
      google-compute-engine
      grpcurl
      hcloud
      hdparm
      hwdata
      inetutils
      inotify-tools
      iotop
      iperf
      isync
      # junkie
      k9s
      keychain
      kind
      kubectx
      libguestfs
      lshw
      lsof
      ltrace
      mailutils
      mcron
      mongodb-compass
      mutt
      ngrok
      nix-index
      nmap
      nox
      openconnect
      # opendkim insecure
      openfortivpn
      openshift
      openvpn
      packer
      parted
      pciutils
      pinentry-curses
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
      sops
      ssh-to-age
      sshfs
      sshpass
      starship
      stern
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
      # kubectl-rabbitmq
      # kubectl-node-shell
      kubernetes
      kubernetes-helm
      socat
      krew
    ] ++ lib.optionals config.myCustomFlags.virtualBoxEnabled [
      virtualbox
      config.boot.kernelPackages.virtualbox
    ] ++ lib.optionals config.myCustomFlags.libvirtdEnabled [ libvirt ];
}
