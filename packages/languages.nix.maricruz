{ config, lib, pkgs, ... }:
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    dart
    elixir
#    elmPackages.elm-compiler
    gcc
    gdb
    gfortran
    gnumake
    go
    libcap
    libtool
    php
    ruby
    tlaplus
    tlaps
    tlaplusToolbox
  ];
}

