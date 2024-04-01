{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    libssh2
    ssh-ident
  ];

  programs.ssh = {
    forwardX11 = true;
    startAgent = true;
    setXAuthLocation = true;
  };
}
