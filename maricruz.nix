{ config, pkgs, options, ... }:

{
  imports = [
    #    <home-manager/nixos>
    #      ./allow-broken.nix
    ./bluetooth.nix
    ./cachix/nix-community.nix
    #    ./environment.nix
    ./maricruz/fonts.nix
    ./nix.nix
    ./nixpkgs.nix
    ./maricruz/packages/3d-printing.nix
    ./packages/android.nix
    ./packages/audio.nix
    ./packages/bash.nix
    ./maricruz/packages/blockchain.nix
    ./maricruz/packages/browsers.nix
    ./packages/crypto.nix
    #    ./packages/cute-vpn-for-smarties.nix
    ./maricruz/packages/desktopapps.nix
    ./packages/devops.nix
    ./maricruz/packages/editors.nix
    #      ./packages/firefox52esr.nix
    ./maricruz/packages/gamedev.nix
    ./maricruz/packages/java.nix
    ./maricruz/packages/jupyter.nix
    ./maricruz/packages/languages.nix
    ./maricruz/packages/latex.nix
    ./maricruz/packages/messaging.nix
    ./maricruz/packages/misc.nix
    ./packages/music.nix
    ./packages/nix.nix
    ./packages/nodejs.nix
    #    ./packages/openssl-insecure.nix
    ./packages/pharo.nix
    ./maricruz/packages/programming.nix
    ./maricruz/packages/publishing.nix
    ./packages/python.nix
    ./packages/screensavers.nix
    ./maricruz/packages/shells.nix
    ./packages/ssh.nix
    ./maricruz/packages/version-control.nix
    ./maricruz/packages/x11.nix
    ./packages/xmonad.nix
    ./packages/wayland.nix
    ./maricruz/private/audio.nix
    ./maricruz/private/boot-common.nix
    ./maricruz/private/boot-multimonitor.nix
    ./private/console.nix
    # ./private/clients.nix
    #    ./private/configs/xmonad.nix
    ./maricruz/private/filesystems.nix
    ./private/filesystems-remote.nix
    #    ./private/font-size.nix
    ./maricruz/private/hardware.nix
    ./private/i18n.nix
    ##      ./private/location.nix
    ./maricruz/private/power.nix
    ./private/location.nix
    ./private/networking.nix
    ./private/nix.nix
    ./maricruz/private/packages.nix
    ./private/packages/games.nix
    #      ./private/services/alsa.nix
    ./private/services/autofs.nix
    ./private/services/apache.nix
    #    ./private/services/cron.nix
    ./maricruz/private/services/docker.nix
    ./maricruz/private/services/kubernetes.nix
    ./maricruz/private/services/openvpn.nix
    ./private/services/postfix.nix
    # ./private/services/nvidia.nix
    ./private/services/remove-rt-locks.nix
    ./private/services/ssmtp.nix
    ./private/services/syncthing.nix
    ./private/services/udev.nix
    ./maricruz/private/services/xserver/common-multimonitor.nix
    ./maricruz/private/services/configs/xmonad-multimonitor.nix
    #    ./private/services/xserver/i3.nix
    ./maricruz/private/services/xserver/xserver-multimonitor.nix
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
    ./maricruz/services/dunst.nix
    ./services/emacs.nix
    ./services/hydra.nix
    ./maricruz/services/libvirtd.nix
    ./services/locate.nix
    ./services/logind.nix
    ./services/mongodb.nix
    ./services/nix-gc.nix
    ./services/nix-serve.nix
    ./maricruz/services/redshift.nix
    ./maricruz/packages/machine-learning.nix
    ./maricruz/private/packages/machine-learning.nix
    ./services/samba.nix
    ./services/ssh.nix
    ./maricruz/services/swayidle.nix
    ./services/trezord.nix
    ./services/unclutter.nix
    ./services/upower.nix
    ./services/urxvtd.nix
    ./maricruz/services/udiskie.nix
    #    ./services/virtualbox.nix
    ./services/vsftpd.nix
    ./services/xcape.nix
    ./system.nix
    ./unfree.nix
    ./maricruz/unsafe.nix
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
