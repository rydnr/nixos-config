{ config, lib, pkgs, ... }:

{
  services = {
    pulseaudio = {
      enable = true;
      support32Bit = true;
      systemWide = false;
#      configFile = "/etc/pulse/pulseaudio.pa";
      extraConfig = ''
#load-module module-alsa-sink sink_name=creative device=hw:0
#load-module module-alsa-sink sink_name=creative device=hw:0 channels=6 channel_map=front-left,front-right,rear-left,rear-right,front-center,lfe
#load-module module-alsa-sink sink_name=nvidia device=hw:1
#load-module module-combine-sink sink_name=combined channels=6 channel_map=front-left,front-right,rear-left,rear-right,front-center,lfe
#load-module module-equalizer-sink
#set-default-sink combined
#set-default-sink creative
#load-module module-dbus-protocol
#set-card-profile alsa_card.pci-0000_03_00.0 output:iec958-stereo
      '';

      package = pkgs.pulseaudioFull;

      daemon = {
        logLevel = "debug";
        config = { "default-sample-channels" = "2"; };
      };
      zeroconf = {
        discovery.enable = true;
        publish.enable = true;
      };
      tcp = {
        enable = true;
        anonymousClients = {
          allowedIpRanges = [ "192.168.8.0/24" ];
        };
      };
    };
  };
}
