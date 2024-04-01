{ config, pkgs, ... }:

{
  # Enable acpid
  services.acpid = {
    enable = true;
  };
}
