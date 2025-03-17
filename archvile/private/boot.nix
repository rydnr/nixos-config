# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  boot = {

    extraModulePackages = [];
    kernelModules = [ "kvm-intel" ];
    loader = {
      efi = {
        canTouchEfiVariables = false;
        efiSysMountPoint = "/boot";
      };
      generationsDir.copyKernels = true;
      grub = {
        enable = true;
        enableCryptodisk = true;
        copyKernels = true;
        devices = [ "nodev" ];
        efiInstallAsRemovable = true;
        efiSupport = true;
        useOSProber = true;
        theme = pkgs.nixos-grub2-theme;
      };
    };
 
    initrd = {
      availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "usb_storage" "sd_mod" ];
      kernelModules = [ "dm-snapshot" ];
      luks.devices = {
        "crypt-nvme0n1p5" = { device = "/dev/disk/by-uuid/5909f9a7-11a3-4f66-9078-9ef3a15d3b72"; preLVM = true; };
      };
    };
  };
}
