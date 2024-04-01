{ config, pkgs, ... }:

{
  # Enable UPower, which is used by taffybar.
  services.upower.enable = true;
  systemd.services.upower.enable = true;
}
