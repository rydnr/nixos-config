{ config, lib, pkgs, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs;
    [
      #    libmoz2d
      #    pharo
      #    pharo-cog32
      #   pharo-spur32
      pharo-spur64
      # pharo-launcher
    ];
}
