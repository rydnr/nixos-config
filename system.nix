{ config, pkgs, ... }:

{
  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "23.11";

  system.autoUpgrade.enable = true;

  system.autoUpgrade.channel = "https://channels.nixos.org/nixos-23.11";
}
