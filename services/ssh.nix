{ config, pkgs, ... }:

{
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    settings = { X11Forwarding = true; };
    allowSFTP = true;
    #gatewayPorts = true;
    openFirewall = true;
  };
}
