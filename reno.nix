{ config, pkgs, options, ... }: {
  imports = [
    ./cachix/nix-community.nix
    ./nix.nix
    ./private/filesystems-remote.nix
    ./private/i18n.nix
    ./private/time.nix
    ./private/users.nix
    ./reno/custom-flags.nix
    ./reno/packages/bash.nix
    ./reno/packages/devops.nix
    ./reno/packages/editors.nix
    ./reno/packages/nix.nix
    ./reno/packages/version-control.nix
    ./reno/private/boot-common.nix
    ./reno/private/console.nix
    ./reno/private/filesystems.nix
    ./reno/private/hardware.nix
    ./reno/private/packages/machine-learning.nix
    ./reno/private/power.nix
    ./reno/private/networking.nix
    ./reno/private/nix.nix
    ./reno/private/services/docker.nix
    ./reno/private/services/kubernetes.nix
    ./reno/services/libvirtd.nix
    ./security.nix
    ./services/acpid.nix
    ./services/atd.nix
    ./services/logind.nix
    ./services/nix-gc.nix
    ./services/nix-serve.nix
    ./services/ssh.nix
    ./system.nix
    ./unfree.nix
  ];
  nix.settings = {
    extra-substituters = [
      # Populated by the CI in ggerganov/llama.cpp
      "https://llama-cpp.cachix.org"
    ];

    # Verify these are the same keys as published on
    # - https://app.cachix.org/cache/llama-cpp
    extra-trusted-public-keys = [
      "llama-cpp.cachix.org-1:H75X+w83wUKTIPSO1KWy9ADUrzThyGs8P5tmAbkWhQc="
    ];
  };
}
