{ config, lib, pkgs, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    cachix
    home-manager
    #       nix-alien
    niv
    nix
    nix-index
    nix-prefetch-git
    nix-serve # cache local builds
    nixfmt-classic
  ];
}
