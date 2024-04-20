{ config, lib, pkgs, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    antlr4
    bundix
    chromedriver
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
    ktlint
    html-tidy
    libpng.dev
    robo3t
    nitrogen
    #    octave
    pngquant
    ripgrep
    sass
    schemaspy
    shellcheck
    shfmt
    sqlite
    stack
    #    thrift
    watchman
    weka
  ];
}

