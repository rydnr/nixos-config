{ config, pkgs, options, ... }:

{
  imports = [
    ./bluetooth.nix
    ./cachix/nix-community.nix
    ./archvile/custom-flags.nix
    ./archvile/development.nix
    ./archvile/fonts.nix
    ./archvile/packages/3d-printing.nix
    ./archvile/packages/blockchain.nix
    ./archvile/packages/browsers.nix
    ./archvile/packages/desktopapps.nix
    ./archvile/packages/devops.nix
    ./archvile/packages/editors.nix
    ./archvile/packages/gamedev.nix
#    ./archvile/packages/jupyter.nix
    ./archvile/packages/languages.nix
    ./archvile/packages/latex.nix
    ./archvile/packages/messaging.nix
    ./archvile/packages/misc.nix
    ./archvile/packages/programming.nix
    ./archvile/packages/publishing.nix
    ./archvile/packages/python.nix
    ./archvile/packages/shells.nix
    ./archvile/packages/version-control.nix
    ./archvile/packages/wayland.nix
    ./archvile/packages/x11.nix
    ./archvile/private/audio.nix
    ./archvile/private/boot.nix
    ./archvile/private/filesystems.nix
    ./archvile/private/hardware.nix
    ./archvile/private/networking.nix
    ./archvile/private/packages/machine-learning.nix
    ./archvile/private/packages.nix
    ./archvile/private/power.nix
    ./archvile/private/services/docker.nix
#    ./archvile/private/services/kubernetes.nix
#    ./archvile/private/services/raw-kubernetes-ca.nix
#    ./archvile/private/services/raw-kube-apiserver.nix
#    ./archvile/private/services/raw-kube-controller-manager.nix
#    ./archvile/private/services/raw-kube-proxy-certificate.nix
#    ./archvile/private/services/raw-kube-proxy.nix
#    ./archvile/private/services/raw-kube-scheduler.nix
#    ./archvile/private/services/raw-kubelet-certificate.nix
#    ./archvile/private/services/raw-kubelet.nix
    ./archvile/private/services/openvpn.nix
    ./archvile/private/services/xserver/common.nix
#    ./archvile/private/services/xserver/xmonad.nix
    ./archvile/private/services/xserver/i3.nix
    ./archvile/multi-screens.nix
    ./archvile/security.nix
    ./archvile/specialisation.nix
    # PRIVATE_SERVICES_XSERVER
    # ./archvile/single-screen.nix
    ./archvile/multi-screens.nix
    ./archvile/services/dunst.nix
    ./archvile/services/libvirtd.nix
    ./archvile/services/pipewire.nix
    ./archvile/services/redshift.nix
    ./archvile/services/swayidle.nix
    ./archvile/services/udiskie.nix
    ./packages/android.nix
    ./packages/audio.nix
    ./packages/bash.nix
    ./packages/crypto.nix
    ./packages/music.nix
    ./packages/nix.nix
    ./packages/nodejs.nix
    ./packages/pharo.nix
    ./packages/screensavers.nix
    ./packages/ssh.nix
    ./packages/xmonad.nix
    ./private/console.nix
    ./private/filesystems-remote.nix
    ./private/i18n.nix
    ./private/location.nix
    ./private/nix.nix
    ./private/services/apache.nix
    ./private/services/autofs.nix
    ./private/services/postfix.nix
    ./private/services/remove-rt-locks.nix
    ./private/services/ssmtp.nix
    ./private/services/syncthing.nix
    ./private/services/udev.nix
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
    ./services/emacs.nix
    ./services/hydra.nix
    ./services/locate.nix
    ./services/logind.nix
    ./services/mongodb.nix
    ./services/nix-gc.nix
    ./services/nix-serve.nix
    ./services/samba.nix
    ./services/ssh.nix
    ./services/trezord.nix
#    ./services/unclutter.nix
    ./services/upower.nix
    ./services/urxvtd.nix
    ./services/vsftpd.nix
    ./services/xcape.nix
    ./system.nix
    ./unfree.nix

    # <home-manager/nixos>
    # ./allow-broken.nix
    # ./environment.nix
    # ./packages/cute-vpn-for-smarties.nix
    # ./packages/firefox52esr.nix
    # ./packages/openssl-insecure.nix
    # ./private/clients.nix
    # ./private/configs/xmonad.nix
    # ./private/font-size.nix
    # ./private/location.nix
    # ./private/services/alsa.nix
    # ./private/services/cron.nix
    # ./private/services/nvidia.nix
    # ./private/services/xserver/i3.nix
    # ./services/virtualbox.nix
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
