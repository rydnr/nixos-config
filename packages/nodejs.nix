{ config, lib, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    #    nodejs_latest
    nodejs
    #    notmuch-bower
    # serverless
    yarn
  ];
}

