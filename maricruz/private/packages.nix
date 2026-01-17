{ config, lib, pkgs, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs;
    [
      #    burp
      # deadbeef-with-plugins
      #    metasploit-framework
      nzbget
      #    tor-browser-5.0.4
    ];
}
