{ config, lib, pkgs, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment = {
    systemPackages = with pkgs; [
      haskellPackages.ghc
      dmenu # A menu for use with xmonad
      feh # A lightweight image viewer to set backgrounds
      haskellPackages.cabal-install
      haskellPackages.libmpd # Shows MPD status in xmobar
      haskellPackages.xmobar # A minimalistic text-based status bar
      haskellPackages.xmonad
      haskellPackages.xmonad-contrib
      # haskellPackages.xmonad-contrib-gpl
      #      haskellPackages.xmonad-entryhelper
      haskellPackages.xmonad-extras
      #     haskellPackages.xmonad-screenshot
      haskellPackages.xmonad-utils
      #    haskellPackages.xmonad-wallpaper
      haskellPackages.yeganesh
      libnotify # Notification client
      lxqt.lxqt-notificationd
      mpc_cli
      scrot # CLI screen capture utility
      stack
      trayer # A system tray for use with xmonad
      xbrightness
      xcompmgr # X compositing manager
      xorg.xrandr # CLI to X11 RandR extension
      xsettingsd
    ];
  };
}
