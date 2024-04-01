{ config, pkgs, ... }:
{
  systemd.user.services.emacs = {
    description                 = "Emacs: the extensible, self-documenting text editor";

    serviceConfig               = {
      Type      = "forking";
      ExecStart = "emacs --daemon";
      ExecStop  = "emacsclient --eval (kill-emacs)";
      Restart   = "always";
    };
  };
}
