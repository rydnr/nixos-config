{ config, pkgs, ... }: {
  services.logind.settings.Login.HandleLidSwitch = "ignore";
}
