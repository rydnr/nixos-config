{ config, lib, pkgs, ... }:

{
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
    enableExtraSocket = true;
    settings = {
      allow-preset-passphrase = "";
    };
  };
}
