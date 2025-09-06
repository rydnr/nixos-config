{ config, lib, pkgs, ... }: {
  fileSystems."/boot" = {
    #      device = "/dev/disk/by-uuid/b7ad3ee3-425d-4fee-ac65-45674015d64f";
    device = "/dev/nvme1n1p6";
    fsType = "vfat";
    options = [ "noauto" ];
  };
  fileSystems."/" = {
    device = "/dev/gigabyte/root";
    fsType = "ext4";
    options = [ "relatime,discard" ];
  };
  fileSystems."/home/chous" = {
    device = "/dev/home/chous";
    fsType = "ext4";
    options = [ "relatime,discard" ];
  };
  fileSystems."/home/chous/.cache" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [ "defaults,size=12G,noatime,mode=1777,noatime" ];
  };
  #  fileSystems."/home/chous/.mozilla/firefox/4tv9d8tg.dev" = {
  #      device = "tmpfs";
  #      fsType = "tmpfs";
  #      options = [ "defaults,size=25G,noatime,noexec" ];
  #    };
  fileSystems."/var/lib/docker" = {
    device = "/dev/gigabyte/docker";
    fsType = "ext4";
    options = [ "noauto,noatime" ];
  };
  fileSystems."/tmp" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [ "noatime" "nodev" "nosuid" "size=12G" ];
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

  #  fileSystems."/home/chous/sdb1" = {
  #      device = "/dev/disk/by-uuid/56E6A02C7B56C5BB";
  #      fsType = "ntfs";
  #    options = [ "noauto" "defaults" "rw" "user=chous" ];
  #    };

  #  fileSystems."/home/chous/sdb2" = {
  #      device = "/dev/disk/by-uuid/10d815fd-abc3-4072-8176-89ad48d34759";
  #      fsType = "ext3";
  #    options = [ "noauto" "defaults" "rw" "user=chous" ];
  #  };

  #  fileSystems."/home/chous/sdb3" = {
  #      device = "/dev/disk/by-uuid/32d013e5-d92b-4cc7-96bc-ae258997c04a";
  #      fsType = "ext3";
  #    options = [ "noauto" "defaults" "rw" "user=chous" ];
  #  };

  fileSystems."/mnt/ebooks" = {
    device = "//euler/ebooks";
    fsType = "cifs";
    options = [ "noauto" "defaults" "rw" "user=chous" ];
  };

  fileSystems."/mnt/HD-LBU2" = {
    device = "//euler/HD-LBU2";
    fsType = "cifs";
    options = [ "noauto" "defaults" "rw" "user=chous" ];
  };

  fileSystems."/mnt/Samsung-1_5T" = {
    device = "//euler/Samsung-1_5T";
    fsType = "cifs";
    options = [ "noauto" "defaults" "rw" "user=chous" ];
  };

  fileSystems."/mnt/Iomega-HDD" = {
    device = "//euler/Iomega-HDD";
    fsType = "cifs";
    options = [ "noauto" "defaults" "rw" "user=chous" ];
  };

  fileSystems."/mnt/Toshiba-USB3" = {
    device = "//euler/Toshiba-USB3";
    fsType = "cifs";
    options = [ "noauto" "defaults" "rw" "user=chous" ];
  };

  fileSystems."/mnt/Seagate" = {
    device = "//euler/Seagate";
    fsType = "cifs";
    options = [ "noauto" "defaults" "rw" "user=chous" ];
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

  fileSystems."/mnt/crucial" = {
    device = "/dev/disk/by-uuid/96a93d19-6478-466a-8b7e-6a80da8aa74f";
    fsType = "ext4";
    options = [ "noauto" "defaults" "rw" ];
  };

  #  fileSystems."/home/chous/sdg1" = {
  #    device = "/dev/disk/by-uuid/CE4CAF864CAF67C3";
  #    fsType = "auto";
  #    options = [ "noauto" "defaults" "rw" ];
  #  };
}
