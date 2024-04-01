{ config, lib, pkgs, ... }:
{
  nixpkgs.config = {

    permittedInsecurePackages = [
      "openssl-1.0.2u"
    ];
  };
}
