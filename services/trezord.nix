{ config, pkgs, ... }:

{
  services.trezord = {
    enable = true;
  };
}
