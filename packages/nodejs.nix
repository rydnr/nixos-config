{ config, lib, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    #    nodejs_latest
    nodejs
    nodePackages.node2nix
    #    notmuch-bower
    # serverless
    yarn
  ];
}

