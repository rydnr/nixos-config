{ config, pkgs, lib, inputs, ... }: {

  programs = {
    adb.enable = lib.mkDefault true;
    nix-ld.enable = true;
    zsh = {
      autosuggestions.enable = true;
      enable = lib.mkDefault true;
      enableCompletion = true;
      histFile = "$HOME/.cache/.zsh_history";
      histSize = 100000;
      syntaxHighlighting.enable = true;
      ohMyZsh.enable = true;
      ohMyZsh.plugins = [ "sudo" "z" ];
      #    shellInit = ''
      #      source ${pkgs.zsh-forgit}/share/zsh-forgit/forgit.plugin.zsh
      #    '';

      setOptions = [
        "noautomenu"
        "nomenucomplete"
        "AUTO_CD"
        "BANG_HIST"
        "EXTENDED_HISTORY"
        "HIST_EXPIRE_DUPS_FIRST"
        "HIST_FIND_NO_DUPS"
        "HIST_IGNORE_ALL_DUPS"
        "HIST_IGNORE_DUPS"
        "HIST_IGNORE_SPACE"
        "HIST_REDUCE_BLANKS"
        "HIST_SAVE_NO_DUPS"
        "INC_APPEND_HISTORY"
        "SHARE_HISTORY"
      ];

    };
  };
}
