{ config, pkgs, options, ... }:

{
  imports = [
    ./bluetooth.nix
    ./cachix/nix-community.nix
    ./maricruz/custom-flags.nix
    ./maricruz/development.nix
    ./maricruz/fonts.nix
    ./maricruz/packages/3d-printing.nix
    ./maricruz/packages/blockchain.nix
    ./maricruz/packages/browsers.nix
    ./maricruz/packages/desktopapps.nix
    ./maricruz/packages/devops.nix
    ./maricruz/packages/editors.nix
    ./maricruz/packages/gamedev.nix
    ./maricruz/packages/java.nix
#    ./maricruz/packages/jupyter.nix
    ./maricruz/packages/languages.nix
    ./maricruz/packages/latex.nix
    ./maricruz/packages/messaging.nix
    ./maricruz/packages/misc.nix
    ./maricruz/packages/programming.nix
    ./maricruz/packages/publishing.nix
    ./maricruz/packages/python.nix
    ./maricruz/packages/shells.nix
    ./maricruz/packages/version-control.nix
    ./maricruz/packages/wayland.nix
    ./maricruz/packages/x11.nix
    ./maricruz/private/audio.nix
    ./maricruz/private/boot.nix
    ./maricruz/private/filesystems.nix
    ./maricruz/private/hardware.nix
    ./maricruz/private/networking.nix
    ./maricruz/private/packages/machine-learning.nix
    ./maricruz/private/packages.nix
    ./maricruz/private/power.nix
    ./maricruz/private/services/docker.nix
#    ./maricruz/private/services/kubernetes.nix
#    ./maricruz/private/services/raw-kubernetes-ca.nix
#    ./maricruz/private/services/raw-kube-apiserver.nix
#    ./maricruz/private/services/raw-kube-controller-manager.nix
#    ./maricruz/private/services/raw-kube-proxy-certificate.nix
#    ./maricruz/private/services/raw-kube-proxy.nix
#    ./maricruz/private/services/raw-kube-scheduler.nix
#    ./maricruz/private/services/raw-kubelet-certificate.nix
#    ./maricruz/private/services/raw-kubelet.nix
    ./maricruz/private/services/openvpn.nix
    ./maricruz/private/services/xserver/common.nix
#    ./maricruz/private/services/xserver/xmonad.nix
    ./maricruz/private/services/xserver/i3.nix
    ./maricruz/multi-screens.nix
    ./maricruz/security.nix
    ./maricruz/specialisation.nix
    # PRIVATE_SERVICES_XSERVER
    # ./maricruz/single-screen.nix
    ./maricruz/multi-screens.nix
    ./maricruz/services/dunst.nix
    ./maricruz/services/libvirtd.nix
    ./maricruz/services/pipewire.nix
    ./maricruz/services/redshift.nix
    ./maricruz/services/swayidle.nix
    ./maricruz/services/udiskie.nix
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
