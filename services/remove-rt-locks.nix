{ config, lib, pkgs, ... }:
{
  systemd.services.removeRtLocks = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Type = "forking";
      User = "chous";
      ExecStart = ''/home/chous/bin/rt-cleanup.sh'';
    };
  };
}
