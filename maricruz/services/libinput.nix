{ config, pkgs, ... }:

{
  services.libinput = {
    # Enable touchpad support.
    enable = true;
    touchpad.tapping = false;
  };
}
