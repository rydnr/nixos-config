{
  description =
    "Systemd service that launches the shared Hermes gateway at boot";

  outputs = { self, ... }: {
    nixosModules.default = { lib, pkgs, ... }: {
      systemd.services.hermes-gateway = {
        description = "Hermes Gateway (shared profile)";
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          Type = "simple";
          # sudo's setuid wrapper lives in /run/wrappers/bin on NixOS, not
          # under /run/current-system/sw — systemd's default PATH omits it,
          # so the script's bare `sudo` calls fail with "command not found".
          Environment = "PATH=/run/wrappers/bin:/run/current-system/sw/bin";
          ExecStart =
            "/run/current-system/sw/bin/hermes-pc /srv/agent-workspaces/shared/hermes gateway";
          Restart = "on-failure";
          RestartSec = 5;
        };
      };
    };
  };
}
