{ config, pkgs, ... }:

{
  # Enable nix-gc
  nix.gc.automatic = true;
  nix.gc.dates = "weekly on Sat at 03:15";
}
