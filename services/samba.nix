{ config, pkgs, ... }: {
  services.samba = {
    enable = true;
    securityType = "user";
    extraConfig = ''
      [global]
        map to guest = Bad User
        guest account = nobody
      [share]
        path = /home/chous/ftp
        read only = no
        guest ok = yes
        create mask = 0777
        directory mask = 0777
    '';
  };
}
