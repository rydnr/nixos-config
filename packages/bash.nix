{ config, lib, pkgs, ... }:
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    bash
    bashmount
  ];

  programs.bash = {
    completion = {
      enable = true;
    };
  };
}
