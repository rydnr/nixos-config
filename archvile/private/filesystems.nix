{ config, lib, pkgs, ... }: {
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/1C15-7AE4";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077"];
  };
  fileSystems."/" = {
    device = "/dev/colordigital/root";
    fsType = "ext4";
    options = [ "relatime" "discard" ];
  };
  fileSystems."/home" = {
    device = "/dev/colordigital/home";
    fsType = "ext4";
    options = [ "relatime" "discard" ];
  };
  fileSystems."/home/chous/.cache" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [ "defaults" "size=6G" "noatime" "mode=1777" "noatime" ];
  };
  #  fileSystems."/home/chous/.mozilla/firefox/4tv9d8tg.dev" = {
  #      device = "tmpfs";
  #      fsType = "tmpfs";
  #      options = [ "defaults" "size=25G" "noatime" "noexec" ];
  #    };
  fileSystems."/var/lib/docker" = {
    device = "/dev/colordigital/docker";
    fsType = "ext4";
    options = [ "relatime" "discard" ];
  };
  fileSystems."/tmp" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [ "noatime" "nodev" "nosuid" "size=6G" ];
  };
  swapDevices = [{ device = "/dev/disk/by-label/swap"; }];

  fileSystems."/windows" = {
    device = "/dev/nvme0n1p3";
    fsType = "ntfs";
    options = [ "noauto" "defaults" "rw" ];
  };

  fileSystems."/mnt/seagate" = {
    device = "/dev/disk/by-uuid/CE4CAF864CAF67C3";
    fsType = "ntfs";
    options = [ "noauto" "defaults" "rw" ];
  };

  fileSystems."/mnt/nas-public" = {
    device = "//nas/PUBLIC";
    fsType = "cifs";
    options = [
      "noauto"
      "defaults"
      "rw"
      "uid=1000"
      "user=chous"
      "credentials=/home/chous/.lp/nas"
      "exec"
      "users"
      "vers=1.0"
    ];
  };

  fileSystems."/mnt/nas-media" = {
    device = "//nas/MEDIA";
    fsType = "cifs";
    options = [
      "noauto"
      "defaults"
      "rw"
      "uid=1000"
      "user=chous"
      "credentials=/home/chous/.lp/nas"
      "exec"
      "users"
      "vers=1.0"
    ];
  };

  fileSystems."/mnt/nas-music" = {
    device = "//nas/MUSIC";
    fsType = "cifs";
    options = [
      "noauto"
      "defaults"
      "rw"
      "uid=1000"
      "user=chous"
      "credentials=/home/chous/.lp/nas"
      "exec"
      "users"
      "vers=1.0"
    ];
  };

  fileSystems."/mnt/nas-pictures" = {
    device = "//nas/PICTURES";
    fsType = "cifs";
    options = [
      "noauto"
      "defaults"
      "rw"
      "uid=1000"
      "user=chous"
      "credentials=/home/chous/.lp/nas"
      "exec"
      "users"
      "vers=1.0"
    ];
  };

  fileSystems."/mnt/nas-jose" = {
    device = "//nas/jose";
    fsType = "cifs";
    options = [
      "noauto"
      "defaults"
      "rw"
      "uid=1000"
      "user=chous"
      "credentials=/home/chous/.lp/nas"
      "exec"
      "users"
      "vers=1.0"
    ];
  };

  fileSystems."/mnt/nas-books" = {
    device = "//nas/BOOKS";
    fsType = "cifs";
    options = [
      "noauto"
      "defaults"
      "rw"
      "uid=1000"
      "user=chous"
      "credentials=/home/chous/.lp/nas"
      "exec"
      "users"
      "vers=1.0"
    ];
  };

  fileSystems."/mnt/nas-uploads" = {
    device = "//nas/UPLOADS";
    fsType = "cifs";
    options = [
      "noauto"
      "defaults"
      "rw"
      "uid=1000"
      "user=chous"
      "credentials=/home/chous/.lp/nas"
      "exec"
      "users"
      "vers=1.0"
    ];
  };

  fileSystems."/mnt/nas-ana" = {
    device = "//nas/ana";
    fsType = "cifs";
    options = [
      "noauto"
      "defaults"
      "rw"
      "uid=1000"
      "user=chous"
      "credentials=/home/chous/.lp/nas"
      "exec"
      "users"
      "vers=1.0"
    ];
  };

  fileSystems."/mnt/seagate2T" = {
    device = "/dev/disk/by-id/ata-ST2000DM001-9YN164_W2F0GFM0-part1";
    fsType = "ntfs";
    options = [ "noauto" "defaults" "rw" ];
  };

  fileSystems."/mnt/redLed1T" = {
    device = "/dev/disk/by-uuid/401D-C87B";
    fsType = "ntfs";
    options = [ "noauto" "defaults" "rw" ];
  };

  #  fileSystems."/home/chous/sdg1" = {
  #    device = "/dev/disk/by-uuid/CE4CAF864CAF67C3";
  #    fsType = "auto";
  #    options = [ "noauto" "defaults" "rw" ];
  #  };
}
