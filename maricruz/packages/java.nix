{ config, lib, pkgs, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    ant
    eclipses.eclipse-sdk
    jdt-language-server
    # ecj
    jdk
    jetbrains.idea-ultimate
    graalvmPackages.graalvm-ce
    gradle
    grails
    groovy
    maven
    #    oraclejdk
    openjdk17
    vscode
  ];

  nixpkgs.config = {
    #    oraclejdk.accept_license = true;
  };
  programs.java = {
    enable = true;
    package = pkgs.openjdk17;
  };
}
