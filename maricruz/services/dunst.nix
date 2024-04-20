{ config, pkgs, ... }:
{
  systemd.user.services."dunst" = {
    enable = false;
    description = "";
    wantedBy = [ "default.target" ];
    serviceConfig.Restart = "always";
    serviceConfig.RestartSec = 2;
    serviceConfig.ExecStart = "${pkgs.dunst}/bin/dunst";
  };
}
