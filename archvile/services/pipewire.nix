{ config, pkgs, ... }: {
  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    alsa.enable = true;
    jack.enable = true;
  };
}
