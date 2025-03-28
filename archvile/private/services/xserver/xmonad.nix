{ config, pkgs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver = {

    windowManager = {
      xmonad = {
        enable = true;
        enableContribAndExtras = true;
        extraPackages = with pkgs.haskellPackages; haskellPackages: [
          yeganesh
          xmobar
          xmonad
          xmonad-contrib
          xmonad-extras
        ];
      };
    };
  };
}
