{ config, lib, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # copilot-language-server
    ];
}
