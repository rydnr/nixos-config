{ config, pkgs, ... }:

{
  # MongoDB
  services.mongodb = {
      enable = false;
  };
}
