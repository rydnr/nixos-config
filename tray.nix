{ config, pkgs, options, ... }: {
  imports = [
    ./cachix/nix-community.nix
    ./nix.nix
    ./private/filesystems-remote.nix
    ./private/i18n.nix
    ./private/time.nix
    ./private/users.nix
    ./security.nix
    ./services/acpid.nix
    ./services/atd.nix
    ./services/logind.nix
    ./services/nix-gc.nix
    ./services/nix-serve.nix
    ./services/ssh.nix
    ./system.nix
    ./tray/custom-flags.nix
    ./tray/packages/bash.nix
    ./tray/packages/devops.nix
    ./tray/packages/editors.nix
    ./tray/packages/nix.nix
    ./tray/packages/version-control.nix
    ./tray/private/boot-common.nix
    ./tray/private/boot.nix
    ./tray/private/console.nix
    ./tray/private/filesystems.nix
    ./tray/private/hardware.nix
    ./tray/private/power.nix
    ./tray/private/networking.nix
    ./tray/private/nix.nix
    ./tray/private/services/docker.nix
    ./tray/private/services/kubernetes.nix
    ./tray/programs.nix
    ./tray/services/libvirtd.nix
    ./unfree.nix
  ];
}
