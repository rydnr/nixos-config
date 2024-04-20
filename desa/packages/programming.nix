{ config, lib, pkgs, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    bundix
    clang
    clang-tools
    cmake
    compass
    coreutils
    fd
    hlint
    gnuplot
    #    go_bootstrap
    gocode
    gomodifytags
    gore
    gotests
    gotools
    gource
    html-tidy
    libpng.dev
    nitrogen
    #    octave
    pngquant
    ripgrep
    sass
    shellcheck
    shfmt
    sqlite
    stack
    #    thrift
  ];
}

