{ config, lib, pkgs, ... }: {
  programs.zsh = {
    enable = true;
    promptInit =
      "source ${pkgs.zsh-powerlevel9k}/share/zsh-powerlevel9k/powerlevel9k.zsh-theme";
  };
}

