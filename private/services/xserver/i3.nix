{ config, pkgs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "dvp";
    xkbOptions = "eurosign:e,ctrl:swapcaps,terminate:ctrl_alt_bksp";
    dpi = 96;

    videoDrivers = [ "amdgpu" ];
    exportConfiguration = true;
#    xrandrHeads = [
#      { output = "eDP"; primary = true; } # laptop
#    ];

    useGlamor = false;
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
      sessionCommands =  ''
         xrdb "${pkgs.writeText  "xrdb.conf" ''
           URxvt.font:                 xft:Dejavu Sans Mono for Powerline:size=11
           XTerm*faceName:             xft:Dejavu Sans Mono for Powerline:size=11
           XTerm*utf8:                 2
#           URxvt.iconFile:             /usr/share/icons/elementary/apps/24/terminal.svg
           URxvt.letterSpace:          0
           URxvt.background:           #121214
           URxvt.foreground:           #FFFFFF
           XTerm*background:           #121212
           XTerm*foreground:           #FFFFFF
           ! black
           URxvt.color0  :             #2E3436
           URxvt.color8  :             #555753
           XTerm*color0  :             #2E3436
           XTerm*color8  :             #555753
           ! red
           URxvt.color1  :             #CC0000
           URxvt.color9  :             #EF2929
           XTerm*color1  :             #CC0000
           XTerm*color9  :             #EF2929
           ! green
           URxvt.color2  :             #4E9A06
           URxvt.color10 :             #8AE234
           XTerm*color2  :             #4E9A06
           XTerm*color10 :             #8AE234
           ! yellow
           URxvt.color3  :             #C4A000
           URxvt.color11 :             #FCE94F
           XTerm*color3  :             #C4A000
           XTerm*color11 :             #FCE94F
           ! blue
           URxvt.color4  :             #3465A4
           URxvt.color12 :             #729FCF
           XTerm*color4  :             #3465A4
           XTerm*color12 :             #729FCF
           ! magenta
           URxvt.color5  :             #75507B
           URxvt.color13 :             #AD7FA8
           XTerm*color5  :             #75507B
           XTerm*color13 :             #AD7FA8
           ! cyan
           URxvt.color6  :             #06989A
           URxvt.color14 :             #34E2E2
           XTerm*color6  :             #06989A
           XTerm*color14 :             #34E2E2
           ! white
           URxvt.color7  :             #D3D7CF
           URxvt.color15 :             #EEEEEC
           XTerm*color7  :             #D3D7CF
           XTerm*color15 :             #EEEEEC
           URxvt*saveLines:            32767
           XTerm*saveLines:            32767
           URxvt.colorUL:              #AED210
           URxvt.perl-ext:             default,url-select
           URxvt.keysym.M-u:           perl:url-select:select_next
           URxvt.url-select.launcher:  /run/current-system/sw/bin/firefox -new-tab
           URxvt.url-select.underline: true
           Xft*dpi:                    96
           Xft*antialias:              true
           Xft*hinting:                full
           URxvt.scrollBar:            false
           URxvt*scrollTtyKeypress:    true
           URxvt*scrollTtyOutput:      false
           URxvt*scrollWithBuffer:     false
           URxvt*scrollstyle:          plain
           URxvt*secondaryScroll:      true
           Xft.autohint: 0
           Xft.lcdfilter:  lcddefault
           Xft.hintstyle:  hintfull
           Xft.hinting: 1
           Xft.antialias: 1 
         ''}"
         xmodmap -e 'add mod3 = Multi_key'
      '';

#      defaultSession = "none+i3";
      defaultSession = "none+xmonad";

      autoLogin = {
        enable = true;
        user = "chous";
      };
      lightdm = {
        enable = true;
      };
    };

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
      i3 = {
        enable = false;
        extraPackages = with pkgs; [
          dmenu
          i3status
          i3lock
          i3blocks
        ];
      };
    };

    desktopManager = {
      xterm.enable = false;
      xfce.enable = false;
    };

    wacom.enable = true;

    # Enable touchpad support.
    libinput.enable = true;
    libinput.touchpad.tapping = false;
    synaptics.twoFingerScroll = true;
  };
}
