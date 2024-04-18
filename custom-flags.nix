{ lib, config, ... }: {
  options.myCustomFlags = {
    androidToolsEnabled = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable Android tools.";
    };
    audioEnabled = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable audio.";
    };
    davfs2Enabled = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable davfs2.";
    };
    dockerEnabled = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable Docker.";
    };
    kubernetesEnabled = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable Kubernetes.";
    };
    libvirtdEnabled = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable libvirtd.";
    };
    networkManagerEnabled = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable NetworkManager.";
    };
    printingEnabled = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable printing.";
    };
    virtualBoxEnabled = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable VirtualBox.";
    };
  };

  config = { };
}
