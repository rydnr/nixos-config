{ config, pkgs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver = {

    videoDrivers = [ "amdgpu" ];
    exportConfiguration = true;
#    xrandrHeads = [
#      { output = "eDP"; primary = true; } # laptop
#    ];

    displayManager = {
      sessionCommands = pkgs.lib.mkAfter ''
          xmodmap -e 'add mod3 = Super_L'
      '';
    };
 
 };
}
