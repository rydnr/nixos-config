{ config, pkgs, ... }:

{
  services.displayManager = {

    defaultSession = "none+i3";

    autoLogin = {
      enable = true;
      user = "chous";
    };
  };
}
