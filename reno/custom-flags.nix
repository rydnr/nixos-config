{ config, pkgs, lib, ... }: {

  imports = [ ../custom-flags.nix ];

  config.myCustomFlags = {
    androidToolsEnabled = false;
    audioEnabled = false;
    davfs2Enabled = false;
    dockerEnabled = true;
    kubernetesEnabled = true;
    libvirtdEnabled = true;
    networkManagerEnabled = false;
    printingEnabled = false;
    virtualBoxEnabled = false;
  };
}
