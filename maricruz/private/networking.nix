{ config, lib, pkgs, ... }: {

  # Create a service that configures ath0 only when it appears
  systemd.services."configure-ath0" = {
    description = "Configure ath0 WiFi when plugged in";
    script = ''
      # Wait for the interface to appear
      while [ ! -e /sys/class/net/ath0 ]; do
        sleep 1
      done

      # Bring up the interface with DHCP
      ${pkgs.dhcpcd}/bin/dhcpcd ath0
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "no";
    };
    wantedBy = [ "multi-user.target" ];
  };

  services.udev.extraRules = ''
    # eth0
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="80:FA:5B:99:81:9F", NAME="eth0"

    # Wifi
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="C0:3C:59:CE:40:41", NAME="wlan0"

    # Atheros
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="00:c0:ca:98:0b:1d", NAME="ath0"
      RUN+="${pkgs.systemd}/bin/systemctl start configure-ath0.service"
  '';

  networking = {
    hostName = "maricruz";

    extraHosts = ''
      127.0.0.1 localhost jenkins.acm-sl.org.local maven.acm-sl.org.local
      ::1 localhost ip6-localhost ip6-loopback

      192.168.1.5 netgate
      fd06:f14a:8df8::05 netgate

      192.168.1.6 orange1
      fd06:f14a:8df8::06 orange1

      192.168.1.7 orange2
      fd06:f14a:8df8::07 orange2

      192.168.1.8 nas
      # fd06:f14a:8df8::08 nas

      192.168.1.9 adguard
      fd06:f14a:8df8::09 adguard

      192.168.1.10 reno nexus.acm-sl.org docker.acm-sl.org
      fd06:f14a:8df8::0a reno nexus.acm-sl.org docker.acm-sl.org

      192.168.1.11 tray
      fd06:f14a:8df8::0b tray

      192.168.1.12 desa
      fd06:f14a:8df8::0c desa

      192.168.1.13 thales
      fd06:f14a:8df8::0d thales

      192.168.1.14 vcenter
      fd06:f14a:8df8::0e vcenter

      192.168.1.15 nuka
      fd06:f14a:8df8::0f nuka

      192.168.1.16 netgear
      fd06:f14a:8df8::10 netgear

      # 192.168.1.17 netgate
      fd06:f14a:8df8::11 netgate

      192.168.1.18 asusrt
      fd06:f14a:8df8::12 asusrt

      192.168.1.19 nife
      fd06:f14a:8df8::13 nife

      192.168.1.20 euler
      fd06:f14a:8df8::14 euler

      192.168.1.21 maricruz
      fd06:f14a:8df8::15 maricruz
      fe80::82fa:5bff:fe99:819f maricruz

      192.168.1.22 archvile
      fd06:f14a:8df8::17 archvile

      192.168.1.23 javi
      fd06:f14a:8df8::17 javi

      192.168.1.24 ana
      fd06:f14a:8df8::18 ana

      192.168.1.25 lucia
      fd06:f14a:8df8::19 lucia

      192.168.1.26 mountain
      fd06:f14a:8df8::1a mountain

      192.168.1.27 witworks
      fd06:f14a:8df8::1b witworks

      192.168.1.30 printer
      fd06:f14a:8df8::1e printer

      192.168.1.41 maricruzwf
      fd06:f14a:8df8::29 maricruzwf
    '';

    firewall = {
      enable = true;
      #        iptables -t nat -A POSTROUTING -s 10.3.0.0/24 -o enp110s0 -j MASQUERADE
      #        iptables -t nat -A POSTROUTING -s 10.4.0.0/24 -o enp110s0 -j MASQUERADE
      extraCommands = ''
                iptables -A INPUT  -p tcp -m tcp --dport 80 -m conntrack --ctstate ESTABLISHED,NEW -j ACCEPT -m comment --comment "Allow http connections on port 80"
                iptables -A OUTPUT -p tcp -m tcp --dport 21 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT -m comment --comment "Allow ftp connections on port 21"
                iptables -A INPUT  -p tcp -m tcp --dport 21 -m conntrack --ctstate ESTABLISHED,NEW -j ACCEPT -m comment --comment "Allow ftp connections on port 21"
                iptables -A OUTPUT -p tcp -m tcp --dport 21 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT -m comment --comment "Allow ftp connections on port 21"
                iptables -A INPUT  -p tcp -m tcp --dport 20 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT -m comment --comment "Allow ftp connections on port 20"
                iptables -A OUTPUT -p tcp -m tcp --dport 20 -m conntrack --ctstate ESTABLISHED -j ACCEPT -m comment --comment "Allow ftp connections on port 20"
                iptables -A INPUT  -p tcp -m tcp --sport 1024: --dport 1024: -m conntrack --ctstate ESTABLISHED -j ACCEPT -m comment --comment "Allow passive inbound connections"
                iptables -A OUTPUT -p tcp -m tcp --sport 1024: --dport 1024: -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT -m comment --comment "Allow passive inbound connections"
                iptables -A INPUT  -p tcp -m tcp --dport 587 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT -m comment --comment "Allow SMTP connections on port 587"
                iptables -A OUTPUT -p tcp -m tcp --dport 587 -m conntrack --ctstate ESTABLISHED -j ACCEPT -m comment --comment "Allow SMTP connections on port 587"
                iptables -A INPUT  -p tcp -m tcp --dport 25 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT -m comment --comment "Allow SMTP connections on port 587"
                iptables -A OUTPUT -p tcp -m tcp --dport 25 -m conntrack --ctstate ESTABLISHED -j ACCEPT -m comment --comment "Allow SMTP connections on port 25"
                iptables -A INPUT -p tcp -m tcp --dport 465 -m conntrack --ctstate ESTABLISHED -j ACCEPT -m comment --comment "Allow SMTP connections on port 25"
                iptables -A OUTPUT -p tcp -m tcp --dport 465 -m conntrack --ctstate ESTABLISHED -j ACCEPT -m comment --comment "Allow SMTP connections on port 25"
                iptables -t nat -A PREROUTING -p tcp --dport 465 -j REDIRECT --to-ports 25
                iptables -t nat -A PREROUTING -p tcp --dport 587 -j REDIRECT --to-ports 25
        #        iptables -A INPUT -i vboxnet0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT -m comment --comment "Allow connections from vboxnet0"
                iptables -A INPUT -m pkttype --pkt-type multicast -j ACCEPT -m comment --comment "Allow multicast traffic"
                iptables -A INPUT -m pkttype --pkt-type broadcast -j ACCEPT -m comment --comment "Allow broadcast traffic"
                iptables -A INPUT  -p tcp -m tcp --dport 10250 -m conntrack --ctstate ESTABLISHED,NEW -j ACCEPT -m comment --comment "Allow kubelet connections port 10250"
                iptables -A INPUT  -p tcp -m tcp --dport 10256 -m conntrack --ctstate ESTABLISHED,NEW -j ACCEPT -m comment --comment "Allow kube-proxy connections port 10256"
                iptables -A INPUT  -p tcp -m tcp --dport 30000:32767 -m conntrack --ctstate ESTABLISHED,NEW -j ACCEPT -m comment --comment "Allow nodeport connections ports 30000 to 32767 (TCP)"
                iptables -A INPUT  -p udp -m udp --dport 30000:32767 -m conntrack --ctstate ESTABLISHED,NEW -j ACCEPT -m comment --comment "Allow nodeport connections ports 30000 to 32767 (UDP)"
      '';
      #      extraStopCommands = ''
      #        iptables -t nat -D POSTROUTING -s 10.3.0.0/24 -o enp110s0 -j MASQUERADE -m comment --comment "masquerade 10.3.0.0/24"
      #        iptables -t nat -D POSTROUTING -s 10.4.0.0/24 -o enp110s0 -j MASQUERADE -m comment --comment "masquerade 10.4.0.0/24"
      #      '';
      allowedUDPPorts = [ 1194 1195 ];
      trustedInterfaces = [ "tun0" ];
      #      trustedInterfaces = [ "vboxnet0" ];
    };

    nat = {
      enable = true;
      internalInterfaces = [ "eth0" "wlan0" ];
      internalIPs = [ "192.168.1.0/24" ];
      externalInterface = "tun0";
    };

    wireless = {
      enable = true;
      interfaces = [ "wlan0" ];
      #      userControlled = true;
      networks = {
        #network={
        #        ssid="POCO X7 Pro"
        #        #psk="javisanleandro"
        #        psk=f4022145519db452edb8f13b5cdf09684701f99965fdf76d1b5397a3fd5942b1
        #}
        # network={
        #        ssid="Redmi Note 12 Pro+ 5G"
        #        #psk="rguj1305"
        #        psk=82388773c023200795a0df359a9a81a696f3aa854fcd22cdf83692867e875aa7
        #}
        #network={
        #	ssid="MIWIFI_ScSy_EXT"
        #	#psk="UAe3yP4K"
        #	psk=7a7af9d2c7a8434a6e56ea917621c36321530dba2439b782d8d1d6b4dad4cfa4
        #}
        #network={
        #	ssid="MIWIFI_ScSy"
        #	#psk="UAe3yP4K"
        #	psk=7a7af9d2c7a8434a6e56ea917621c36321530dba2439b782d8d1d6b4dad4cfa4
        #}
        #network={
        #	ssid="MIWIFI_ScSy_5G_EXT"
        #	#psk="UAe3yP4K"
        #	psk=7a7af9d2c7a8434a6e56ea917621c36321530dba2439b782d8d1d6b4dad4cfa4
        #}
        "bradyon" = {
          psk = "Bxd/eDNFWRYG+cmfz50kqr21u8C14xj4iUh8RKnRqsqZAhABeOKatpnjZW24";
          # psk = "363b5447d7dbb0170a3701705cb29220afe808e3c23c7f5417f2c43170d1055a";
        };
      };
    };

    useDHCP = false;

    defaultGateway = "192.168.1.1";
    defaultGateway6 = "fd06:f14a:8df8::01";

    interfaces = {
      enp5s0 = {
        useDHCP = false;
        ipv4 = {
          addresses = [{
            address = "192.168.1.21";
            prefixLength = 24;
          }];
        };
        ipv6 = {
          addresses = [{
            address = "fd06:f14a:8df8::15";
            prefixLength = 64;
          }];
        };
      };
      wlp2s0 = {
        useDHCP = false;
        ipv4 = {
          addresses = [{
            address = "192.168.1.41";
            prefixLength = 24;
          }];
        };
        ipv6 = {
          addresses = [{
            address = "fd06:f14a:8df8::29";
            prefixLength = 64;
          }];
        };
      };
      wlan0 = {
        useDHCP = false;
        ipv4 = {
          addresses = [{
            address = "192.168.1.41";
            prefixLength = 24;
          }];
        };
        ipv6 = {
          addresses = [{
            address = "fd06:f14a:8df8::29";
            prefixLength = 64;
          }];
        };
      };
      ath0 = { useDHCP = true; };
    };
    nameservers = [
      "192.168.1.9"
      "8.8.8.8"
      "fd06:f14a:8df8::09"
      "2001:4860:4860::8888" # Google Public DNS IPv6
      "2001:4860:4860::8844" # Google Public DNS IPv6
      "2606:4700:4700::1111" # Cloudflare DNS IPv6
      "2606:4700:4700::1001" # Cloudflare DNS IPv6
    ];
  };
}
