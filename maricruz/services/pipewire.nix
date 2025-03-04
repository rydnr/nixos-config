{ config, pkgs, ... }: {
  services.pipewire = {
    enable = false;
  };
}
