{ config, lib, pkgs, ... }:
{
  environment = {
    etc = {
      "xmonad/xmonad.hs".text = ''
-- xmonad config used by Vic Fryzel
-- Author: Vic Fryzel
-- https://github.com/vicfryzel/xmonad-config

import Control.Monad (liftM2)
import System.IO
import System.Exit
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import Graphics.X11.ExtraTypes.XF86
import qualified XMonad.StackSet as W
import qualified Data.Map        as M


------------------------------------------------------------------------
-- Terminal
-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal = "~/bin/term.sh"

-- The command to lock the screen or show the screensaver.
myScreensaver = "/run/current-system/sw/bin/xscreensaver-command -lock; xset dpms force off"

-- The command to take a selective screenshot, where you select
-- what you'd like to capture on the screen.
mySelectScreenshot = "select-screenshot"

-- The command to take a fullscreen screenshot.
myScreenshot = "screenshot"

-- The command to use as a launcher, to launch commands that don't have
-- preset keybindings.
-- myLauncher = "$(yeganesh -x -- -fn 'monospace-8' -nb '#000000' -nf '#FFFFFF' -sb '#7C7C7C' -sf '#CEFFAC')"
myLauncher = "dmenu_run -b -nb black"

-- Location of your xmobar.hs / xmobarrc
myXmobarrc = "~/.xmonad/xmobar-single.hs"


------------------------------------------------------------------------
-- Workspaces
-- The default number of workspaces (virtual screens) and their names.
--
myWorkspaces = ["1:term","2:emacs","3:firefox","4:slack", "5:pharo","6:aws","7:idea","8:postman","9:misc","10:other","11:another"]


------------------------------------------------------------------------
-- Window rules
-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
-- Java stuff: AWT_TOOLKIT=MToolkit and _JAVA_AWT_WM_NONREPARENTING=1
myManageHook = composeAll
    [ className =? "Emacs"            --> doShift "2:emacs"
    , className =? "Firefox"          --> doShift "3:firefox"
    , className =? "Chromium-browser" --> doShift "4:chrome"
    , className =? "Slack"            --> doShift "4:chrome"
    , className =? "pharo-vm"         --> doShift "5:pharo"
    , resource  =? "desktop_window"   --> doIgnore
    , className =? "Steam"            --> doFloat
    , className =? "Gimp"             --> doFloat
    , resource  =? "gpicview"         --> doFloat
    , className =? "MPlayer"          --> doFloat
    , className =? "VirtualBox"       --> doShift "6:misc"
    , className =? "stalonetray"      --> doIgnore
    , className =? "jetbrains-idea"   --> doShift "7:idea"
    , className =? "robo3t"           --> doShift "10:other"
    , className =? "calibre"          --> doShift "9:misc"
    , isFullscreen --> (doF W.focusDown <+> doFullFloat)]


------------------------------------------------------------------------
-- Layouts
-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout = avoidStruts (
    ThreeColMid 1 (3/100) (1/2) |||
    Tall 1 (3/100) (1/2) |||
    Mirror (Tall 1 (3/100) (1/2)) |||
    tabbed shrinkText tabConfig |||
    Full |||
    spiral (6/7)) |||
    noBorders (fullscreenFull Full)


------------------------------------------------------------------------
-- Colors and borders
-- Currently based on the ir_black theme.
--
myNormalBorderColor  = "#7c7c7c"
myFocusedBorderColor = "#ffb6b0"

-- Colors for text and backgrounds of each tab when in "Tabbed" layout.
tabConfig = defaultTheme {
    activeBorderColor = "#7C7C7C",
    activeTextColor = "#CEFFAC",
    activeColor = "#000000",
    inactiveBorderColor = "#7C7C7C",
    inactiveTextColor = "#EEEEEE",
    inactiveColor = "#000000"
}

-- Color of current window title in xmobar.
xmobarTitleColor = "#FFB6B0"

-- Color of current workspace in xmobar.
xmobarCurrentWorkspaceColor = "#CEFFAC"

-- Width of the window border in pixels.
myBorderWidth = 3


------------------------------------------------------------------------
-- Key bindings
--
-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
-- myModMask = mod1Mask -- Alt_L
-- myModMask = mod1Mask -- Alt_R
-- myModMask = mod2Mask -- Numlock key
-- myModMask = mod3Mask -- (unset)
-- myModMask = mod4Mask -- Super_L (Win)
-- myModMask = mod5Mask -- “ISO_Level3_Shift” key.
myModMask = mod3Mask -- multimonitor
-- myModMask = mod4Mask -- nomonitor

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
  ----------------------------------------------------------------------
  -- Custom key bindings
  --

  -- Start a terminal.  Terminal to start is specified by myTerminal variable.
  [ ((modMask .|. shiftMask, xK_Return),
     spawn $ XMonad.terminal conf)

  -- Lock the screen using command specified by myScreensaver.
  , ((modMask .|. controlMask, xK_l),
     spawn myScreensaver)

  -- Spawn the launcher using command specified by myLauncher.
  -- Use this to launch programs without a key binding.
  , ((modMask, xK_p),
     spawn myLauncher)

  -- Take a selective screenshot using the command specified by mySelectScreenshot.
  , ((modMask .|. shiftMask, xK_y),
     spawn mySelectScreenshot)

  -- Take a full screenshot using the command specified by myScreenshot.
  , ((modMask .|. controlMask .|. shiftMask, xK_y),
     spawn myScreenshot)

  -- Mute volume.
  , ((0, xF86XK_AudioMute),
     spawn "amixer -q set Master toggle")

  -- Decrease volume.
  , ((0, xF86XK_AudioLowerVolume),
     spawn "amixer -q set Master 5%-")

  -- Increase volume.
  , ((0, xF86XK_AudioRaiseVolume),
     spawn "amixer -q set Master 5%+")

  -- Mute volume.
  , ((modMask .|. controlMask, xK_m),
     spawn "amixer -q set Master toggle")

  -- Decrease volume.
  , ((modMask .|. controlMask, xK_j),
     spawn "amixer -q set Master 5%-")

  -- Increase volume.
  , ((modMask .|. controlMask, xK_k),
     spawn "amixer -q set Master 5%+")

  -- Audio previous.
  , ((0, 0x1008FF16),
     spawn "")

  -- Play/pause.
  , ((0, 0x1008FF14),
     spawn "")

  -- Audio next.
  , ((0, 0x1008FF17),
     spawn "")

  -- Eject CD tray.
  , ((0, 0x1008FF2C),
     spawn "eject -T")

  --------------------------------------------------------------------
  -- "Standard" xmonad key bindings
  --

  -- Close focused window.
  , ((modMask .|. shiftMask, xK_c),
     kill)

  -- Cycle through the available layout algorithms.
  , ((modMask, xK_space),
     sendMessage NextLayout)

  --  Reset the layouts on the current workspace to default.
  , ((modMask .|. shiftMask, xK_space),
     setLayout $ XMonad.layoutHook conf)

  -- Resize viewed windows to the correct size.
  , ((modMask, xK_n),
     refresh)

  -- Move focus to the next window.
  , ((modMask, xK_Tab),
     windows W.focusDown)

  -- Move focus to the next window.
  , ((modMask, xK_j),
     windows W.focusDown)

  -- Move focus to the previous window.
  , ((modMask, xK_k),
     windows W.focusUp  )

  -- Move focus to the master window.
  , ((modMask, xK_m),
     windows W.focusMaster  )

  -- Swap the focused window and the master window.
  , ((modMask, xK_Return),
     windows W.swapMaster)

  -- Swap the focused window with the next window.
  , ((modMask .|. shiftMask, xK_j),
     windows W.swapDown  )

  -- Swap the focused window with the previous window.
  , ((modMask .|. shiftMask, xK_k),
     windows W.swapUp    )

  -- Shrink the master area.
  , ((modMask, xK_h),
     sendMessage Shrink)

  -- Expand the master area.
  , ((modMask, xK_l),
     sendMessage Expand)

  -- Push window back into tiling.
  , ((modMask, xK_t),
     withFocused $ windows . W.sink)

  -- Increment the number of windows in the master area.
  , ((modMask, xK_comma),
     sendMessage (IncMasterN 1))

  -- Decrement the number of windows in the master area.
  , ((modMask, xK_period),
     sendMessage (IncMasterN (-1)))

  -- Toggle the status bar gap.
  -- TODO: update this binding with avoidStruts, ((modMask, xK_b),

  -- keybindings for programs
  , ((modMask, xK_e), spawn "emacs")
  , ((modMask, xK_f), spawn "firefox")
--  , ((modMask, xK_p), spawn "pidgin")
  , ((modMask, xK_c), spawn "chromium")
  , ((modMask, xK_g), spawn "gimp")
  , ((modMask, xK_b), spawn "blender")
  , ((modMask, xK_i), spawn "idea-ultimate")

  -- Quit xmonad.
  , ((modMask .|. shiftMask, xK_q),
     io (exitWith ExitSuccess))

  -- Restart xmonad.
  , ((modMask, xK_q),
     restart "xmonad" True)

  , ((modMask, xK_q), spawn "cd ~/.xmonad, nix-shell --pure --command 'ghc --make xmonad.hs -i -ilib -fforce-recomp -v0 -o xmonad-x86_64-linux' && xmonad --restart")

  ]
  ++

  -- mod-[1..9], Switch to workspace N
  -- mod-shift-[1..9], Move client to workspace N
  [((m .|. modMask, k), windows $ f i)
      | (i, k) <- zip (XMonad.workspaces conf) [xK_F1 .. xK_F12]
      , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
  ++

  -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
  -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
  [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
      | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
      , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
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


------------------------------------------------------------------------
-- Status bars and logging
-- Perform an arbitrary action on each internal state change or X event.
-- See the 'DynamicLog' extension for examples.
--
-- To emulate dwm's status bar
--
-- > logHook = dynamicLogDzen
--
--


------------------------------------------------------------------------
-- Startup hook
-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = return ()

------------------------------------------------------------------------
-- Run xmonad with all the defaults we set up.
--
main = do
  xmproc <- spawnPipe ("xmobar " ++ myXmobarrc)
  xmonad $ defaults {
        logHook = dynamicLogWithPP $ defaultPP

      -- display current workspace as darkgrey on light grey (opposite of
      -- default colors)
         {  ppCurrent         = dzenColor "#303030" "#909090" . pad

         -- display other workspaces which contain windows as a brighter grey
          , ppHidden          = dzenColor "#909090" "" . pad

         -- display other workspaces with no windows as a normal grey
          , ppHiddenNoWindows = dzenColor "#606060" "" . pad

         -- display the current layout as a brighter grey
          , ppLayout          = dzenColor "#909090" "" . pad

         -- if a window on a hidden workspace needs my attention, color it so
          , ppUrgent          = dzenColor "#ff0000" "" . pad . dzenStrip

         -- shorten if it goes over 100 characters
          , ppTitle           = shorten 100

        -- no separator between workspaces
          , ppWsSep           = ""

        -- put a few spaces between each object
          , ppSep             = "  "

        -- output to the handle we were given as an argument
--          , ppOutput          = hPutStrLn h
        }
---      logHook = h
--              = dynamicLogWithPP $ xmobarPP {
--            ppOutput = hPutStrLn xmproc
--          , ppTitle = xmobarColor xmobarTitleColor "" . shorten 100
--          , ppCurrent = xmobarColor xmobarCurrentWorkspaceColor ""
--          , ppSep = "   "
--      }
      , manageHook = manageDocks <+> myManageHook
--      , startupHook = docksStartupHook <+> setWMName "LG3D"
      , startupHook = setWMName "LG3D"
      , handleEventHook = docksEventHook
  }


------------------------------------------------------------------------
-- Combine it all together
-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = defaultConfig {
    -- simple stuff
    terminal           = myTerminal,
    focusFollowsMouse  = myFocusFollowsMouse,
    borderWidth        = myBorderWidth,
    modMask            = myModMask,
    workspaces         = myWorkspaces,
    normalBorderColor  = myNormalBorderColor,
    focusedBorderColor = myFocusedBorderColor,

    -- key bindings
    keys               = myKeys,
    mouseBindings      = myMouseBindings,

    -- hooks, layouts
    layoutHook         = smartBorders $ myLayout,
    manageHook         = myManageHook,
    startupHook        = myStartupHook
}
    '';

    "xmobar/config".text = ''
Config { font = "-misc-fixed-*-*-*-*-10-*-*-*-*-*-*-*"
       , borderColor = "black"
       , border = TopB
       , bgColor = "black"
       , fgColor = "grey"
       , position = Top
       , lowerOnStart = True
       , persistent = True
       , commands = [ Run Weather "EGPF" ["-t","<station>: <tempC>C","-L","18","-H","25","--normal","green","--high","red","--low","lightblue"] 36000
                    , Run Network "enp110s0" ["-L","0","-H","32","--normal","green","--high","red"] 10
                    , Run Network "wlp113s0" ["-L","0","-H","32","--normal","green","--high","red"] 10
                    , Run Cpu ["-L","7","-H","50","--normal","green","--high","red"] 10
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
                    ]
       , sepChar = "%"
       , alignSep = "}{"
       , template = "%battery% | %cpu% | %memory% | %enp110s0% - %wlp113s0% }{ <fc=#ee9a00>%date%</fc>"
       }
      '';
    };
  };
}
