{ config, lib, pkgs, ... }: {
  programs.adb.enable = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  #  android_sdk.accept_license = true;
  environment.systemPackages = with pkgs;
    [
      #    androidndk
      #    android-studio
      #    androidenv.buildTools
      #    android-udev-rules
      #    apktool
      #    androidenv.platformTools
      #    androidenv.androidsdk_9_0
      #    androidenv.androidsdk_9_0_extras
      #    ant
      #    idea.android-studio-fhs
      #    (myEnvFun {
      #      name = "android100";
      #      buildInputs = [ androidenv.androidsdk_10_0
      #                      androidenv.androidsdk_10_0_extras
      #                      ant
      #                      openjdk
      #                    ];
      #    })
      #     gmtp
      mtpfs
    ];
}
