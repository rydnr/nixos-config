{ config, pkgs, lib, ... }: {

  imports = [ ../custom-flags.nix ];

  config.myCustomFlags = {
    androidToolsEnabled = true;
    audioEnabled = true;
    davfs2Enabled = true;
    dockerEnabled = true;
    kubernetesEnabled = true;
    libvirtdEnabled = true;
    networkManagerEnabled = false;
    printingEnabled = true;
    virtualBoxEnabled = false;
  };
}
