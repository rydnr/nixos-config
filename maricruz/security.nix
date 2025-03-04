{ config, lib, pkgs, ... }: {
  security.pam.loginLimits =
  let entry = type: {
    inherit type;
    domain = "*";
    item = "rtprio";
    value = "2";
  }; in [ (entry "hard") (entry "soft") ];
}
