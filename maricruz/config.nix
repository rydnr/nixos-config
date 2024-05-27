{ config, lib, pkgs, ... }: {
  nixpkgs.config = {
    checkMeta = true;
    cudaSupport = true;
    warnUndeclaredOptions = true;
  };
}
