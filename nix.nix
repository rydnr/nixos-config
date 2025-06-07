{ config, lib, pkgs, ... }: {
  nix = {
    extraOptions = "experimental-features = nix-command flakes";
    package = pkgs.nixVersions.stable;
  };

  nixpkgs.overlays = [
    (final: prev: {
      linuxPackages = prev.linuxPackages_latest;
    })
  ];
}
