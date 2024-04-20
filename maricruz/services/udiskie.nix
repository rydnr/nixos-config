{ config, pkgs, ... }: {
  systemd.user.services."udiskie" = {
    enable = true;
    description = "udiskie to automount removable media";
    wantedBy = [ "default.target" ];
    path = with pkgs; [
      gnome3.adwaita-icon-theme
      gnome3.gnome-themes-extra
      udiskie
    ];
    environment.XDG_DATA_DIRS =
      "${pkgs.gnome3.adwaita-icon-theme}/share:${pkgs.gnome3.gnome-themes-extra}/share";
    serviceConfig.Restart = "always";
    serviceConfig.RestartSec = 2;
    serviceConfig.ExecStart = "${pkgs.udiskie}/bin/udiskie -a -t -n -F ";
  };
}
