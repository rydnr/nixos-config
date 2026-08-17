# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  boot = {

    kernelPackages = pkgs.linuxPackages_latest;
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

      availableKernelModules =
        [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];

      luks.devices = {
        "crypt-nvme0n1p7" = {
          # device = "/dev/disk/by-uuid/7af12b29-1ee0-47dc-a206-d5084071c5d5";
          device = "/dev/nvme0n1p7";
          preLVM = true;
        };
        "crypt-nvme1n1p1" = {
          # device = "/dev/disk/by-uuid/2de46aa7-cebe-4561-be89-378967f4df99";
          device = "/dev/nvme1n1p1";
          preLVM = true;
        };
      };
    };
  };
}
