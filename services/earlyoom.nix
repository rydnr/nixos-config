{ config, lib, pkgs, ... }: {
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5; # Kill if free RAM falls below 5%
    freeSwapThreshold = 10; # Kill if free Swap falls below 10%
    extraArgs = [
      "--prefer 'java'" # Tell earlyoom to prefer killing Java/IntelliJ processes over your desktop environment
    ];
  };
}
