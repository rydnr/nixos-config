{ config, pkgs, ... }:

{
  # The NixOS release to be compatible with for stateful data such as databases.
  system = {
    stateVersion = "23.11";
    autoUpgrade = {
      enable = true;
      channel = "https://channels.nixos.org/nixos-23.11";
    };

    activationScripts = {
      checkCdrom = {
        text = ''
          if [ -e /dev/cdrom ]; then
            usermod -a -G cdrom chous
          fi
        '';
        deps = [ "users" ];
      };
    };
  };
}
