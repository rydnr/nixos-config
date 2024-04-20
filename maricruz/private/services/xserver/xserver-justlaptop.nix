{ config, pkgs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver = {

    videoDrivers = [ "amdgpu" ];
    exportConfiguration = true;
#    xrandrHeads = [
#      { output = "eDP"; primary = true; } # laptop
#    ];

     config = pkgs.lib.mkAfter ''

Section "Monitor"
  Identifier "eDP"
  Option "Primary" "true"
  Option "Enable" "true"
EndSection

Section "Screen"
  Identifier "Screen-amdgpu-eDP"
  Device "Device-amdgpu"
  Monitor "eDP"
  Option "AllowEmptyInitialConfiguration"
EndSection

Section "Device"
  Identifier "Device-amdgpu"
  Driver "amdgpu"

  BusID "PCI:6:0:0"

  Option "Monitor-eDP" "eDP"

  Option "UseDisplayDevice" "eDP"
  Option "RenderAccel" "true"
  VendorName "ATI"
  BoardName "Cezanne"
  Screen 0

EndSection

Section "ServerLayout"
  Identifier "Layout"

#  Reference the Screen sections for each driver.  This will
#  cause the X server to try each in turn.
  Screen "Screen-amdgpu-eDP"

EndSection
'';
    displayManager = {
      sessionCommands = pkgs.lib.mkAfter ''
          xmodmap -e 'add mod3 = Super_L'
      '';
    };
 
 };
}
