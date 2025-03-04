{ config, pkgs, ... }:
{
  systemd.user.services."urxvtd" = {
    enable = true;
    description = "rxvt unicode daemon";
    wantedBy = [ "default.target" ];
    path = [ pkgs.rxvt-unicode-unwrapped ];
    serviceConfig.Restart = "always";
    serviceConfig.RestartSec = 2;
    serviceConfig.ExecStart = "${pkgs.rxvt-unicode-unwrapped}/bin/urxvtd -q -o";
  };
}
