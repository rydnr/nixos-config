{ config, pkgs, ... }:
{
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  security.pam.loginLimits = [{
    domain = "*";
    type = "soft";
    item = "nofile";
    value = "4096";
  }
  {
     domain = "*";
    type = "soft";
    item = "rtprio";
    value = "2";
  }
  {
    domain = "*";
    type = "hard";
    item = "rtprio";
    value = "2";
  }];
}
