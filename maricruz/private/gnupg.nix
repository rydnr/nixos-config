{ config, lib, pkgs, ... }:

{
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    enableExtraSocket = true;
    settings = {
      allow-preset-passphrase = "";
    };
  };
}
