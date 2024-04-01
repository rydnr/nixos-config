# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "23.11";

  system.autoUpgrade.enable = true;

  system.autoUpgrade.channel = "https://channels.nixos.org/nixos-23.11";
}
