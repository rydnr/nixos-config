{ config, pkgs, ... }: {
  services.vsftpd = {
    enable = true;
    anonymousUserHome = "/tmp/ftp/uploads";
    anonymousUser = true;
    anonymousUploadEnable = true;
    anonymousMkdirEnable = true;
    anonymousUserNoPassword = true;
    anonymousUmask = "0000";
    localUsers = true;
    writeEnable = true;
  };
}
