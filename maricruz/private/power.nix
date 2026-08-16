{ config, pkgs, ... }:

{
  services.upower.enable = true;

  powerManagement.enable = true;
  powerManagement.scsiLinkPolicy = "min_power";
  #  powerManagement.cpuFreqGovernor = "powersave";
  powerManagement.cpuFreqGovernor = "performance";
}
