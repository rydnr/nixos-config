{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs;
  [
    linuxPackages.nvidia_x11
  ];

  boot = {
    blacklistedKernelModules = [ "pcspkr" "padlock_aes" "vboxsf" "vboxnetflt" "vboxnetadp" "vboxdrv" "nouveau" ];

    extraModulePackages = [
#      config.boot.kernelPackages.nvidia_x11
#      pkgs.linuxPackages.amdgpu-pro
      pkgs.linuxPackages.virtualbox
      pkgs.linuxPackages.v4l2loopback
    ];
    kernelParams = [ "modeset=0" "v4l2loopback.exclusive_caps=1" ];
    initrd = {
      kernelModules = [
#        "kvm-amd"
#        "fbcon"
        "dm_snapshot"
#        "vboxdrv"
#        "vboxnetadp"
#        "vboxnetflt"
        "dm_crypt"
        "sha256"
        "sha1"
        "cbc"
#        "aes_x86_64"
        "aes"
        "xts"
        "nvidia"
        "nvidiafb"
        "nvidia-uvm"
        "nvidia-drm"
        "amdgpu"
      ];

      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usb_storage"
        "sd_mod"
        "sdhci_pci"
#        "vboxdrv"
#        "vboxnetadp"
#        "vboxnetflt"
#        "fbcon"
        "v4l2loopback"
        "nvidia"
        "nvidiafb"
        "nvidia-uvm"
        "nvidia-drm"
        "amdgpu"
      ];
    };
  };

  hardware = {
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.beta;
#      package = config.boot.kernelPackages.nvidiaPackages.stable;
#      package = pkgs.linuxPackages.nvidiaPackages.latest;
#      package = config.boot.kernelPackages.nvidiaPackages.latest;

      # package = config.boot.kernelPackages.nvidia_x11;
#      package = config.boot.kernelPackages.nvidiaPackages.latest;
      prime = {
        offload.enable = false;
        sync.enable = true;
        nvidiaBusId = "PCI:1:0:0";
        amdgpuBusId = "PCI:6:0:0";
      };
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false;
      nvidiaPersistenced = true;
      nvidiaSettings = true;
    };
    graphics.enable = true;
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
#    videoDrivers = [ "amdgpu" "nvidia" ]; # doesn't work
    exportConfiguration = true;
#    xrandrHeads = [
#      { output = "HDMI-0"; } # dell
##      { output = "eDP"; primary = true; } # laptop
#      { output = "DP-0"; monitorConfig = "Option \"Rotate\" \"left\""; } # samsung-vertical
#      { output = "DP-2"; } # samsung-4k
#    ];

     config = ''

Section "ServerLayout"

#  Reference the Screen sections for each driver.  This will
#  cause the X server to try each in turn.
    Identifier     "Layout"
    Screen         "Screen-nvidia-DP-2" 0 0
    Screen         "Screen-nvidia-DP-0" 0 0
    Screen         "Screen-nvidia-HDMI-0" 0 0
    InputDevice    "Keyboard0" "CoreKeyboard"
    InputDevice    "Mouse0" "CorePointer"
EndSection

Section "ServerFlags"
    Option         "AllowMouseOpenFail" "on"
    Option         "DontZap" "on"
EndSection

Section "InputDevice"
    # generated from default
    Identifier     "Keyboard0"
    Driver         "kbd"
EndSection

Section "InputDevice"
    # generated from default
    Identifier     "Mouse0"
    Driver         "mouse"
    Option         "Protocol" "auto"
    Option         "Device" "/dev/input/mice"
    Option         "Emulate3Buttons" "no"
    Option         "ZAxisMapping" "4 5"
EndSection

Section "InputClass"
    Identifier         "libinput mouse configuration"
    MatchIsPointer     "on"
    MatchDriver        "libinput"
    Option         "AccelProfile" "adaptive"
    Option         "LeftHanded" "off"
    Option         "MiddleEmulation" "on"
    Option         "NaturalScrolling" "off"
    Option         "ScrollMethod" "twofinger"
    Option         "HorizontalScrolling" "on"
    Option         "SendEventsMode" "enabled"
    Option         "Tapping" "on"
    Option         "TappingDragLock" "on"
    Option         "DisableWhileTyping" "off"
EndSection

Section "InputClass"
    Identifier         "libinput touchpad configuration"
    MatchIsTouchpad    "on"
    MatchDriver        "libinput"
    Option         "AccelProfile" "adaptive"
    Option         "LeftHanded" "off"
    Option         "MiddleEmulation" "on"
    Option         "NaturalScrolling" "off"
    Option         "ScrollMethod" "twofinger"
    Option         "HorizontalScrolling" "on"
    Option         "SendEventsMode" "enabled"
    Option         "Tapping" "off"
    Option         "TappingDragLock" "on"
    Option         "DisableWhileTyping" "off"
EndSection

Section "Monitor"
    Identifier     "Monitor[0]"
EndSection

Section "Monitor"
    Identifier     "DP-2"
    Option         "Primary" "true"
    Option         "Rotate" "inverted"
    Option         "PreferredMode" "3840x2160"
    Option         "Enable" "true"
EndSection

Section "Monitor"
    Identifier     "DP-0"
    Option         "RightOf" "DP-2"
    Option         "Rotate" "left"
    Option         "PreferredMode" "1680x1050"
    Option         "Position" "3840 0"
    Option         "Enable" "true"
EndSection

Section "Monitor"
    Identifier     "HDMI-0"
    Option         "RightOf" "DP-0"
    Option         "PreferredMode" "1920x1080"
    Option         "Position" "4890 434"
    Option         "Enable" "true"
EndSection

Section "Device"
    Identifier     "nvidia"
    Driver         "nvidia"
    VendorName     "NVIDIA Corporation"
    BoardName      "GeForce RTX 3070 mobile"
    Option         "Monitor-DP-2" "DP-2"
    Option         "Monitor-DP-0" "DP-0"
    Option         "Monitor-HDMI-0" "HDMI-0"
    Option         "UseDisplayDevice" "DP-2"
    Option         "RenderAccel" "true"
    BusID          "PCI:1:0:0"
    Screen          0
EndSection

Section "Screen"
    Identifier     "Screen-nvidia-DP-0"
    Device         "nvidia"
    Monitor        "DP-0"
    Option         "AllowEmptyInitialConfiguration"
EndSection

Section "Screen"
    Identifier     "Screen-nvidia-HDMI-0"
    Device         "nvidia"
    Monitor        "HDMI-0"
    Option         "AllowEmptyInitialConfiguration"
EndSection

Section "Screen"
    Identifier     "Screen-nvidia-DP-2"
    Device         "nvidia"
    Monitor        "DP-2"
    Option         "AllowEmptyInitialConfiguration"
EndSection

Section "Screen"
    Identifier     "Screen0"
    Device         "nvidia"
    Monitor        "Monitor0"
    DefaultDepth    24
    Option         "Stereo" "0"
    Option         "nvidiaXineramaInfoOrder" "DFP-0"
#    Option         "metamodes" "DP-2: nvidia-auto-select +1050+120 {rotation=inverted}, HDMI-0: nvidia-auto-select +1050+120, DP-0: nvidia-auto-select +0+0 {rotation=left}"
    Option         "metamodes" "DP-2: nvidia-auto-select +0+0 {rotation=invert}, HDMI-0: nvidia-auto-select +4890+481, DP-0: nvidia-auto-select +3840+361 {rotation=left}"
    Option         "SLI" "Off"
    Option         "MultiGPU" "Off"
    Option         "BaseMosaic" "Off"
    SubSection     "Display"
        Depth       24
    EndSubSection
EndSection

'';
    displayManager = {
      sessionCommands =  ''
#         su - chous 'xmonad --recompile' || echo "nevermind"
#         ls -lthlia ~/.Xauthority ~/.xmonad >> /tmp/session.log
#         chown chous:users /home/chous/.Xauthority
#         rm -f /home/chous/.xmonad/xmonad-x86_64-linux
         xmodmap -e 'add mod3 = Multi_key'
      '';
      lightdm = { enable = true; };
    };
  };

  environment = {
    etc = {
      "xmonad/xmonad.hs".text = ''
import XMonad
import XMonad.Hooks.DynamicLog (xmobarPP, dynamicLogWithPP, ppOutput)
import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.Hooks.ManageDocks (avoidStruts, docks, manageDocks, docksEventHook)
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Layout.NoBorders
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Util.Hacks as Hacks
import XMonad.Util.Run (spawnPipe, hPutStrLn)
import Graphics.X11.ExtraTypes.XF86
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import System.Exit (exitWith, ExitCode(ExitSuccess))
import XMonad.Util.SpawnOnce

------------------------------------------------------------------------
-- Basic settings
myTerminal = "xterm"  -- Set your default terminal here
myModMask = mod4Mask
myBorderWidth = 3  -- Window border width
myXmobarrcDp2 = "/home/chous/.xmonad/xmobarrc-dp2"
myXmobarrcDp0 = "/home/chous/.xmonad/xmobarrc-dp0"
myXmobarrcHdmi0 = "/home/chous/.xmonad/xmobarrc-hdmi0"

myWorkspaces = ["1:term","2:emacs","3:firefox","4:slack", "5:pharo","6:devops","7:idea","8:postman","9:calibre","10:chrome","11:misc"]

------------------------------------------------------------------------
-- ManageHook: define where to send specific applications
myManageHook = manageDocks <+> composeAll
    [ className =? "Emacs"          --> doShift "2:emacs"
    , className =? "firefox"        --> doShift "3:firefox"
    , className =? "Slack"          --> doShift "4:slack"
    , className =? "discord"        --> doShift "4:slack"
    , className =? "pharo-vm"       --> doShift "5:pharo"
    , className =? "jetbrains-idea" --> doShift "7:idea"
    , className =? "postman"        --> doShift "8:postman"
    , className =? "calibre"        --> doShift "9:calibre"
    , className =? "Chromium"       --> doShift "10:chrome"
    , isDialog                      --> doFloat
    , isFullscreen                  --> (doF W.focusDown <+> doFullFloat)
    ]

------------------------------------------------------------------------
-- Layout: define how windows are laid out
myLayout = avoidStruts $ layoutHook def

-----------------------------------------------------------------------------------------
-- Mouse bindings
--
-- Focus rules
-- True if your focus should follow your mouse cursor.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
  [
    -- mod-button1, Set the window to floating mode and move by dragging
    ((modMask, button1),
     (\w -> focus w >> mouseMoveWindow w))

    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, button2),
       (\w -> focus w >> windows W.swapMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, button3),
       (\w -> focus w >> mouseResizeWindow w))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
  ]

-------------------------------------------------------
-- Key bindings: custom keys for launching apps and managing windows
myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
  [
      ((modMask .|. shiftMask, xK_Return), spawn $ XMonad.terminal def)  -- Launch terminal
    , ((modMask, xK_p), spawn "dmenu_run")  -- Launch dmenu
    , ((modMask .|. shiftMask, xK_c), kill)
    , ((modMask, xK_space), sendMessage NextLayout)
    , ((modMask, xK_j), windows W.focusUp)
    , ((modMask, xK_k), windows W.focusDown)
    , ((modMask, xK_t), windows W.focusDown)
    , ((modMask .|. shiftMask, xK_t), withFocused $ windows . W.sink)
    , ((modMask, xK_m), windows W.focusMaster)  -- Manually reset focus to master window
      -- Reset the layouts on the current workspace to default
    , ((modMask .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf)
      -- Move focus to the next window
    , ((modMask, xK_Tab), windows W.focusDown)
--  , ((modMask, xK_q), restart "xmonad" True)  -- Restart XMonad
--  , ((modMask .|. shiftMask, xK_q), io (exitWith ExitSuccess))  -- Quit XMonad

  -- Media keys
--  , ((0, xF86XK_AudioMute), spawn "amixer -q set Master toggle")
--  , ((0, xF86XK_AudioLowerVolume), spawn "amixer -q set Master 5%-")
--  , ((0, xF86XK_AudioRaiseVolume), spawn "amixer -q set Master 5%+")
  
  -- Workspace switchings
    , ((modMask, xK_ampersand), windows $ W.greedyView "1:term")
    , ((modMask, xK_F1), windows $ W.greedyView "1:term")
    , ((modMask, xK_bracketleft), windows $ W.greedyView "2:emacs")
    , ((modMask, xK_F2), windows $ W.greedyView "2:emacs")
    , ((modMask, xK_braceleft), windows $ W.greedyView "3:firefox")
    , ((modMask, xK_F3), windows $ W.greedyView "3:firefox")
    , ((modMask, xK_braceright), windows $ W.greedyView "4:slack")
    , ((modMask, xK_F4), windows $ W.greedyView "4:slack")
    , ((modMask, xK_parenleft), windows $ W.greedyView "5:pharo")
    , ((modMask, xK_F5), windows $ W.greedyView "5:pharo")
    , ((modMask, xK_equal), windows $ W.greedyView "6:devops")
    , ((modMask, xK_F6), windows $ W.greedyView "6:devops")
    , ((modMask, xK_asterisk), windows $ W.greedyView "7:idea")
--    , ((modMask, xK_F7), windows $ W.greedyView "7:idea")
    , ((modMask, xK_parenright), windows $ W.greedyView "8:postman")
--    , ((modMask, xK_F8), windows $ W.greedyView "8:postman")
    , ((modMask, xK_plus), windows $ W.greedyView "9:calibre")
--    , ((modMask, xK_F9), windows $ W.greedyView "9:calibre")
    , ((modMask, xK_exclam), windows $ W.greedyView "10:chrome")
--    , ((modMask, xK_F10), windows $ W.greedyView "10:chrome")
    , ((modMask, xK_numbersign), windows $ W.greedyView "11:misc")
--    , ((modMask, xK_F11), windows $ W.greedyView "11:misc")

    -- mod-shift + symbol, move window to workspace
    , ((modMask .|. shiftMask, xK_ampersand), windows $ W.shift "1:term")
    , ((modMask .|. shiftMask, xK_F1), windows $ W.shift "1:term")
    , ((modMask .|. shiftMask, xK_bracketleft), windows $ W.shift "2:emacs")
    , ((modMask .|. shiftMask, xK_F2), windows $ W.shift "2:emacs")
    , ((modMask .|. shiftMask, xK_braceleft), windows $ W.shift "3:firefox")
    , ((modMask .|. shiftMask, xK_F3), windows $ W.shift "3:firefox")
    , ((modMask .|. shiftMask, xK_braceright), windows $ W.shift "4:slack")
    , ((modMask .|. shiftMask, xK_F4), windows $ W.shift "4:slack")
    , ((modMask .|. shiftMask, xK_parenleft), windows $ W.shift "5:pharo")
    , ((modMask .|. shiftMask, xK_F5), windows $ W.shift "5:pharo")
    , ((modMask .|. shiftMask, xK_equal), windows $ W.shift "6:devops")
    , ((modMask .|. shiftMask, xK_F6), windows $ W.shift "6:devops")
    , ((modMask .|. shiftMask, xK_asterisk), windows $ W.shift "7:idea")
    , ((modMask .|. shiftMask, xK_F7), windows $ W.shift "7:idea")
    , ((modMask .|. shiftMask, xK_parenright), windows $ W.shift "8:postman")
    , ((modMask .|. shiftMask, xK_F8), windows $ W.shift "8:postman")
    , ((modMask .|. shiftMask, xK_plus), windows $ W.shift "9:calibre")
    , ((modMask .|. shiftMask, xK_F9), windows $ W.shift "9:calibre")
    , ((modMask .|. shiftMask, xK_exclam), windows $ W.shift "10:chrome")
    , ((modMask .|. shiftMask, xK_F10), windows $ W.shift "10:chrome")
    , ((modMask .|. shiftMask, xK_numbersign), windows $ W.shift "11:misc")
    , ((modMask .|. shiftMask, xK_F11), windows $ W.shift "11:misc")
  ]

------------------------------------------------------------------------
-- StartupHook: set up applications to run on startup
myStartupHook = do
  setWMName "LG3D"  -- Java apps compatibility
  spawnOnce "/home/chous/.screenlayout/current.sh 2>> ~/.xmonad/screenlayout.errors"
  spawnOnce "emacs"
  -- spawnOnce "firefox --profile /home/chous/.mozilla/firefox/al8xj2m0.Personal/"
  spawnOnce "firefox --profile /home/chous/.mozilla/firefox/4tv9d8tg.dev/"
  spawnOnce "slack"
  spawnOnce "discord"

defaults = def {
    -- simple stuff
      terminal           = myTerminal
    , borderWidth        = myBorderWidth
    , modMask            = myModMask
    , workspaces         = myWorkspaces
    , focusFollowsMouse  = myFocusFollowsMouse

    -- key bindings
    , keys               = myKeys

    -- hooks, layouts
    , layoutHook         = smartBorders $ myLayout
    , manageHook         = myManageHook
    , startupHook        = myStartupHook
    , handleEventHook    = handleEventHook def
}

main = do
  xmprocDp2 <- spawnPipe ("xmobar " ++ myXmobarrcDp2 ++ " 2>> ~/.xmonad/xmobar-dp2.errors")
  xmprocDp0 <- spawnPipe ("xmobar " ++ myXmobarrcDp0  ++ " 2>> ~/.xmonad/xmobar-dp0.errors")
  xmprocHdmi0 <- spawnPipe ("xmobar " ++ myXmobarrcHdmi0 ++ " 2>> ~/.xmonad/xmobar-hdmi0.errors")
  xmonad $ docks $ ewmh $ Hacks.javaHack defaults {
      logHook = dynamicLogWithPP xmobarPP {
        ppOutput = \x -> hPutStrLn xmprocDp2 x >> hPutStrLn xmprocDp0 x >> hPutStrLn xmprocHdmi0 x
      }
  }
    '';

    "xmonad/xmobarrc-dp2".text = ''
Config { font = "-*-fixed-*-*-*-*-12-*-*-*-*-*-*-*"
       , overrideRedirect = True
       , borderColor = "black"
       , border = TopB
       , bgColor = "black"
       , fgColor = "grey"
       , position = OnScreen 0 Top
       , lowerOnStart = True
       , persistent = True
       , commands = [ Run Weather "LEMD" ["-t","<station>: <tempC>C","-L","18","-H","25","--normal","green","--high","red","--low","lightblue"] 36000
                    , Run Network "enp5s0" ["-L","0","-H","32","--normal","green","--high","red"] 10
                    , Run Network "wlp2s0" ["-L","0","-H","32","--normal","green","--high","red"] 10
                    , Run MultiCpu ["-L","7","-H","50","--normal","green","--high","red"] 10
                    , Run Memory ["-t","Mem: <usedratio>%"] 10
                    , Run Com "uname" ["-s","-r"] "" 36000
                    , Run Battery        [ "--template" , "Batt: <acstatus>"
                                         , "--Low"      , "10"        -- units: %
                                         , "--High"     , "80"        -- units: %
                                         , "--low"      , "darkred"
                                         , "--normal"   , "darkorange"
                                         , "--high"     , "darkgreen"
                                         , "--" -- battery specific options
                                                   -- discharging status
                                                   , "-o"	, "<left>% (<timeleft>)"
                                                   -- AC "on" status
                                                   , "-O"	, "<fc=#dAA520>Charging</fc>"
                                                   -- charged status
                                                   , "-i"	, "<fc=#006000>Charged</fc>"
                                         ] 50
		                , Run Date "%a %b %_d %Y %H:%M:%S" "date" 10
                    , Run TopProc ["-n", "1", "-t", "<name> <cpu>%"] 10
                    , Run TopMem ["-n", "1", "-t", "<name> <mem>%"] 10
                    ]
                    , sepChar = "%"
                    , alignSep = "}{"
                    , template = "%battery% | %multicpu% | %memory% | %enp5s0% - %wlp2s0% | %LEMD% }{ <fc=#ee9a00>%date%</fc>"
       }
      '';
    "xmonad/xmobarrc-dp0".text = ''
Config { font = "-*-fixed-*-*-*-*-12-*-*-*-*-*-*-*"
       , overrideRedirect = True
       , borderColor = "black"
       , border = TopB
       , bgColor = "black"
       , fgColor = "grey"
       , position = OnScreen 1 Bottom
       , lowerOnStart = True
       , persistent = True
       , commands = [ 
                      Run Network "enp5s0" ["-L","0","-H","32","--normal","green","--high","red"] 10
                    , Run Network "wlp2s0" ["-L","0","-H","32","--normal","green","--high","red"] 10
                    , Run MultiCpu ["-L","7","-H","50","--normal","green","--high","red"] 10
                    , Run Memory ["-t","Mem: <usedratio>%"] 10
                    , Run Battery        [ "--template" , "Batt: <acstatus>"
                                         , "--Low"      , "10"        -- units: %
                                         , "--High"     , "80"        -- units: %
                                         , "--low"      , "darkred"
                                         , "--normal"   , "darkorange"
                                         , "--high"     , "darkgreen"
                                         , "--" -- battery specific options
                                                   -- discharging status
                                                   , "-o"	, "<left>% (<timeleft>)"
                                                   -- AC "on" status
                                                   , "-O"	, "<fc=#dAA520>Charging</fc>"
                                                   -- charged status
                                                   , "-i"	, "<fc=#006000>Charged</fc>"
                                         ] 50
		                , Run Date "%a %b %_d %Y %H:%M:%S" "date" 10
                    ]
                    , sepChar = "%"
                    , alignSep = "}{"
                    , template = "%battery% | %multicpu% | %memory% | %enp5s0% - %wlp2s0% }{ <fc=#ee9a00>%date%</fc>"
       }
      '';
    "xmonad/xmobarrc-hdmi0".text = ''
Config { font = "-*-fixed-*-*-*-*-12-*-*-*-*-*-*-*"
       , overrideRedirect = True
       , borderColor = "black"
       , border = TopB
       , bgColor = "black"
       , fgColor = "grey"
       , position = OnScreen 2 Top
       , lowerOnStart = True
       , persistent = True
       , commands = [ Run Weather "LEMD" ["-t","<station>: <tempC>C","-L","18","-H","25","--normal","green","--high","red","--low","lightblue"] 36000
                    , Run Network "enp5s0" ["-L","0","-H","32","--normal","green","--high","red"] 10
                    , Run Network "wlp2s0" ["-L","0","-H","32","--normal","green","--high","red"] 10
                    , Run MultiCpu ["-L","7","-H","50","--normal","green","--high","red"] 10
                    , Run Memory ["-t","Mem: <usedratio>%"] 10
                    , Run Com "uname" ["-s","-r"] "" 36000
                    , Run Battery        [ "--template" , "Batt: <acstatus>"
                                         , "--Low"      , "10"        -- units: %
                                         , "--High"     , "80"        -- units: %
                                         , "--low"      , "darkred"
                                         , "--normal"   , "darkorange"
                                         , "--high"     , "darkgreen"
                                         , "--" -- battery specific options
                                                   -- discharging status
                                                   , "-o"	, "<left>% (<timeleft>)"
                                                   -- AC "on" status
                                                   , "-O"	, "<fc=#dAA520>Charging</fc>"
                                                   -- charged status
                                                   , "-i"	, "<fc=#006000>Charged</fc>"
                                         ] 50
		                , Run Date "%a %b %_d %Y %H:%M:%S" "date" 10
                    , Run TopProc ["-n", "1", "-t", "<name> <cpu>%"] 10
                    , Run TopMem ["-n", "1", "-t", "<name> <mem>%"] 10
                    ]
                    , sepChar = "%"
                    , alignSep = "}{"
                    , template = "<fc=#ee9a00>%date%</fc> }{ %LEMD% | %enp5s0% - %wlp2s0% | %memory% | %multicpu% | %battery%"
       }
      '';
    "i3/config".text = ''
# i3 configuration
set $mod Mod4

# Workspaces
set $ws1 1:term
set $ws2 2:emacs
set $ws3 3:firefox
set $ws4 4:slack
set $ws5 5:pharo
set $ws6 6:devops
set $ws7 7:idea
set $ws8 8:postman
set $ws9 9:calibre
set $ws10 10:chrome
set $ws11 11:misc

# Workspace keybindings
bindsym $mod+1 workspace $ws1
bindsym $mod+2 workspace $ws2
bindsym $mod+3 workspace $ws3
bindsym $mod+4 workspace $ws4
bindsym $mod+5 workspace $ws5
bindsym $mod+6 workspace $ws6
bindsym $mod+7 workspace $ws7
bindsym $mod+8 workspace $ws8
bindsym $mod+9 workspace $ws9
bindsym $mod+0 workspace $ws10
bindsym $mod+Shift+exclam workspace $ws11

# Application-specific workspaces
for_window [class="Emacs"] move to workspace $ws2
for_window [class="Firefox"] move to workspace $ws3
for_window [class="Slack"] move to workspace $ws4
for_window [class="jetbrains-idea"] move to workspace $ws7
for_window [class="postman"] move to workspace $ws8
for_window [class="calibre"] move to workspace $ws9
for_window [class="Chromium"] move to workspace $ws10

# Keybindings
bindsym $mod+Return exec xterm
bindsym $mod+p exec dmenu_run
bindsym $mod+Shift+q kill
bindsym $mod+space layout toggle split
bindsym $mod+Shift+r restart

# Moving focus between windows
bindsym $mod+j focus left
bindsym $mod+k focus down
bindsym $mod+l focus up
bindsym $mod+semicolon focus right

# Floating windows
bindsym $mod+Shift+space floating toggle
for_window [window_type="dialog"] floating enable

# Startup applications
exec --no-startup-id emacs
exec --no-startup-id firefox --profile /home/chous/.mozilla/firefox/4tv9d8tg.dev/
exec --no-startup-id slack
exec --no-startup-id ~/.screenlayout/current.sh
      '';
    };
  };
}
