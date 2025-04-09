{ config, pkgs, ... }:

{
  services.libinput = {
    # Enable touchpad support.
    enable = true;
    touchpad.tapping = false;
    # Cursor theme and size
    mouse = {
      accelProfile = "flat";
    };
  };
}
