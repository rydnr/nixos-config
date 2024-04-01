# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, options, ... }:

{
  imports = [
    #    <home-manager/nixos>
    #      ./allow-broken.nix
    ./bluetooth.nix
    ./cachix/nix-community.nix
    #    ./environment.nix
    ./fonts.nix
    ./nix.nix
    ./nixpkgs.nix
    ./packages/3dprinting.nix
    ./packages/android.nix
    ./packages/audio.nix
    ./packages/bash.nix
    ./packages/blockchain.nix
    ./packages/browsers.nix
    ./packages/crypto.nix
    #    ./packages/cute-vpn-for-smarties.nix
    ./packages/desktopapps.nix
    ./packages/devops.nix
    ./packages/editors.nix
    #      ./packages/firefox52esr.nix
    ./packages/gamedev.nix
    ./packages/java.nix
    ./packages/jupyter.nix
    ./packages/languages.nix
    ./packages/latex.nix
    ./packages/machine-learning.nix
    ./packages/messaging.nix
    ./packages/misc.nix
    ./packages/music.nix
    ./packages/nix.nix
    ./packages/nodejs.nix
    #    ./packages/openssl-insecure.nix
    ./packages/pharo.nix
    ./packages/programming.nix
    ./packages/publishing.nix
    ./packages/python.nix
    ./packages/screensavers.nix
    ./packages/shells.nix
    ./packages/ssh.nix
    ./packages/version-control.nix
    ./packages/x11.nix
    ./packages/xmonad.nix
    ./packages/wayland.nix
    ./private/audio.nix
    ./private/boot-common.nix
    ./private/boot.nix
    ./private/console.nix
    # ./private/clients.nix
    #    ./private/configs/xmonad.nix
    ./private/filesystems.nix
    ./private/filesystems-remote.nix
    #    ./private/font-size.nix
    ./private/hardware.nix
    ./private/i18n.nix
    ##      ./private/location.nix
    ./private/power.nix
    ./private/location.nix
    ./private/networking.nix
    ./private/nix.nix
    ./private/packages.nix
    ./private/packages/games.nix
    ./private/packages/machinelearning.nix
    #      ./private/services/alsa.nix
    ./private/services/autofs.nix
    ./private/services/apache.nix
    #    ./private/services/cron.nix
    ./private/services/docker.nix
    #      ./private/services/kubernetes.nix
    ./private/services/openvpn.nix
    ./private/services/postfix.nix
    # ./private/services/nvidia.nix
    ./private/services/remove-rt-locks.nix
    ./private/services/ssmtp.nix
    ./private/services/syncthing.nix
    ./private/services/udev.nix
    ./private/services/xserver/common.nix
    ./private/services/xserver/xmonad.nix
    #    ./private/services/xserver/i3.nix
    ./private/services/xserver/xserver.nix
    ./private/sysctl.nix
    ./private/time.nix
    ./private/users.nix
    ./programs.nix
    ./security.nix
    ./services/acpid.nix
    ./services/atd.nix
    ./services/autocutsel.nix
    ./services/clamav.nix
    ./services/cups.nix
    ./services/dunst.nix
    ./services/emacs.nix
    ./services/hydra.nix
    ./services/libvirtd.nix
    ./services/locate.nix
    ./services/logind.nix
    ./services/mongodb.nix
    ./services/nix-gc.nix
    ./services/nix-serve.nix
    ./services/redshift.nix
    ./services/samba.nix
    ./services/ssh.nix
    ./services/swayidle.nix
    ./services/trezord.nix
    ./services/unclutter.nix
    ./services/upower.nix
    ./services/urxvtd.nix
    ./services/udiskie.nix
    #    ./services/virtualbox.nix
    ./services/vsftpd.nix
    ./services/xcape.nix
    ./system.nix
    ./unfree.nix
    ./unsafe.nix
  ];

  #  nixpkgs.overlays = [ (import /etc/nixos/overlays/rydnr-overlay.nix {}) (import /etc/nixos/overlays/emacs-overlay.nix {}) ];
  #  nixpkgs.overlays = [ (import /etc/nixos/overlays/default.nix)  ];
  #  nixpkgs.overlays = [
  #    (import /etc/nixos/overlays/rydnr-overlay.nix)
  #    (import ./overlays/emacs-overlay.nix)
  #  ];
  #  nixpkgs.overlays = (import /etc/nixos/overlays);
  #  nixpkgs.overlays = [ import /etc/nixos/overlays ];
  #  nix.nixPath =
  #    options.nix.nixPath.default ++
  #    [ "nixpkgs-overlays=/etc/nixos/overlays-compat/overlays.nix" ];
  nix.settings = {
    extra-substituters = [
      # Populated by the CI in ggerganov/llama.cpp
      "https://llama-cpp.cachix.org"

      # A development cache for nixpkgs imported with `config.cudaSupport = true`.
      # Populated by https://hercules-ci.com/github/SomeoneSerge/nixpkgs-cuda-ci.
      # This lets one skip building e.g. the CUDA-enabled openmpi.
      # TODO: Replace once nix-community obtains an official one.
      "https://cuda-maintainers.cachix.org"
    ];

    # Verify these are the same keys as published on
    # - https://app.cachix.org/cache/llama-cpp
    # - https://app.cachix.org/cache/cuda-maintainers
    extra-trusted-public-keys = [
      "llama-cpp.cachix.org-1:H75X+w83wUKTIPSO1KWy9ADUrzThyGs8P5tmAbkWhQc="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };

}
