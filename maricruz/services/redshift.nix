{ config, pkgs, ... }:

{
  services.redshift = {
    enable = true;
    temperature.day = 6500;
    temperature.night = 2700;
    # Redshift with wayland support isn't present in nixos-19.09 atm. You have to cherry-pick the commit from https://github.com/NixOS/nixpkgs/pull/68285 to do that.
    #    package = pkgs.redshift-wlr;
  };
}
