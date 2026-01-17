{ config, lib, pkgs, ... }: {
  nixpkgs.config = {

    permittedInsecurePackages = [ "python3.13-ecdsa-0.19.1" ];
  };
}
