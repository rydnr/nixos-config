{ config, lib, pkgs, ... }:

{
  services.nix-serve = {
    enable = true;
    port = 9999;
  };

  # Ensure the service starts after the network is up
  systemd.services.nix-serve.wants = [ "network.target" ];
  systemd.services.nix-serve.after = [ "network.target" ];
}
