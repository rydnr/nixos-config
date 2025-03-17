{ config, pkgs, ... }:

{
  services.upower.enable = true;

  powerManagement.enable = true;
  powerManagement.scsiLinkPolicy = "min_power";
#  powerManagement.cpuFreqGovernor = "powersave";
  powerManagement.cpuFreqGovernor = "performance";

  powerManagement.powerUpCommands = ''
    echo 'min_power' > '/sys/class/scsi_host/host0/link_power_management_policy';
    echo '1500' > '/proc/sys/vm/dirty_writeback_centisecs';
    echo '1' > '/sys/module/snd_hda_intel/parameters/power_save';
    echo 'min_power' > '/sys/class/scsi_host/host1/link_power_management_policy';
    echo 'min_power' > '/sys/class/scsi_host/host2/link_power_management_policy';
    echo 'auto' > '/sys/bus/usb/devices/1-4/power/control';
    echo 'auto' > '/sys/bus/i2c/devices/i2c-3/device/power/control';
    echo 'auto' > '/sys/bus/usb/devices/1-1/power/control';
    echo 'auto' > '/sys/bus/usb/devices/1-5/power/control';
    echo 'auto' > '/sys/bus/i2c/devices/i2c-1/device/power/control';
    echo 'auto' > '/sys/bus/i2c/devices/i2c-2/device/power/control';
    echo 'auto' > '/sys/bus/pci/devices/0000:00:00.0/power/control';
    echo 'auto' > '/sys/bus/pci/devices/0000:00:00.2/power/control';
    echo 'auto' > '/sys/bus/pci/devices/0000:00:01.0/power/control';
    echo 'auto' > '/sys/bus/pci/devices/0000:00:01.1/power/control';
    echo 'auto' > '/sys/bus/pci/devices/0000:00:01.2/power/control';
    echo 'auto' > '/sys/bus/pci/devices/0000:00:01.3/power/control';
    echo 'auto' > '/sys/bus/pci/devices/0000:00:02.0/power/control';
    echo 'auto' > '/sys/bus/pci/devices/0000:00:02.1/power/control';
    echo 'auto' > '/sys/bus/pci/devices/0000:00:02.4/power/control';
    echo 'auto' > '/sys/bus/pci/devices/0000:00:08.0/power/control';
    echo 'auto' > '/sys/bus/pci/devices/0000:00:08.1/power/control';
    echo 'auto' > '/sys/bus/pci/devices/0000:00:08.2/power/control';
    echo 'auto' > '/sys/bus/pci/devices/0000:00:14.0/power/control';
    echo 'auto' > '/sys/bus/pci/devices/0000:00:14.3/power/control';
    echo 'auto' > '/sys/bus/pci/devices/0000:00:18.0/power/control';
    echo 'auto' > '/sys/bus/pci/devices/0000:00:18.1/power/control';
    echo 'auto' > '/sys/bus/pci/devices/0000:00:18.2/power/control';
    echo 'auto' > '/sys/bus/pci/devices/0000:00:18.3/power/control';
    echo 'auto' > '/sys/bus/pci/devices/0000:00:18.4/power/control';
    echo 'auto' > '/sys/bus/pci/devices/0000:00:18.5/power/control';
    echo 'auto' > '/sys/bus/pci/devices/0000:00:18.6/power/control';
    echo 'auto' > '/sys/bus/pci/devices/0000:00:18.7/power/control';
    echo 'auto' > '/sys/bus/pci/devices/0000:01:00.0/power/control';
    echo 'auto' > '/sys/bus/pci/devices/0000:01:00.1/power/control';
    echo 'auto' > '/sys/bus/pci/devices/0000:02:00.0/power/control';
    echo 'auto' > '/sys/bus/pci/devices/0000:03:00.0/power/control';
    echo 'auto' > '/sys/bus/pci/devices/0000:04:00.0/power/control';
    echo 'auto' > '/sys/bus/pci/devices/0000:05:00.0/power/control';
    echo 'auto' > '/sys/bus/pci/devices/0000:06:00.0/power/control';
    echo 'auto' > '/sys/bus/pci/devices/0000:06:00.1/power/control';
    echo 'auto' > '/sys/bus/pci/devices/0000:06:00.2/power/control';
    echo 'auto' > '/sys/bus/pci/devices/0000:06:00.3/power/control';
    echo 'auto' > '/sys/bus/pci/devices/0000:06:00.4/power/control';
    echo 'auto' > '/sys/bus/pci/devices/0000:06:00.5/power/control';
    echo 'auto' > '/sys/bus/pci/devices/0000:06:00.6/power/control';
    echo 'auto' > '/sys/bus/pci/devices/0000:07:00.0/power/control';
    echo 'auto' > '/sys/bus/pci/devices/0000:07:00.1/power/control';
    ethtool -s enp5s0 wol d;
  '';
}
