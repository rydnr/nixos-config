{ config, lib, pkgs, ... }: {
  environment = {

    systemPackages = with pkgs;
      [
        # copilot-language-server
      ];
    sessionVariables = {
      # Map exact Nix store schema paths to GLib
      XDG_DATA_DIRS = [
        "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
        "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
      ];
      # Direct SSH commands to gnome-keyring's SSH socket
      # SSH_AUTH_SOCK = "\${XDG_RUNTIME_DIR}/gcr/ssh";
    };
  };
}
