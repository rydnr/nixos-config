{ config, pkgs, ... }:
{
  systemd.user.services.emacs = {
    description                 = "Emacs: the extensible, self-documenting text editor";

    serviceConfig               = {
      Type      = "forking";
      ExecStart = "/run/current-system/sw/bin/emacs --daemon";
      ExecStop  = "/run/current-system/sw/bin/emacsclient --eval (kill-emacs)";
      Restart   = "always";
    };
  };
}
