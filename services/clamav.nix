{ config, pkgs, ... }:

{
  # ClamAV antivirus (required to pass host checking in some VPNs)
  services.clamav.daemon.enable = true;
  services.clamav.updater.enable = true;
}
