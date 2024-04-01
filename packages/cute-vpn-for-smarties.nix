{ config, lib, pkgs, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    python3Packages.pyqt5
    python3Packages.pexpect
    python3Packages.google-api-python-client
    python3Packages.google-auth-httplib2
    python3Packages.google-auth-oauthlib
  ];
}

