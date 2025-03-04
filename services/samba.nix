{ config, pkgs, ... }: {
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "guest account" = "nobody";
        "map to guest" = "Bad User";
        "security" = "user";
      };
      share = {
        "path" = "/home/chous/ftp";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0777";
        "directory mask" = "0777";
      };
    };
  };
}
