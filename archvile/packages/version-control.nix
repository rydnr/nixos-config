{ config, lib, pkgs, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    bfg-repo-cleaner
    gitFull
    git
    cgit
    diff-so-fancy
    git-annex-remote-rclone
    #    git-big-picture
    #    gitAndTools.git-codeowners
    git-cola
    git-crypt
    #    gitAndTools.git-dit
    git-extras
    #    gitAndTools.git-fame
    git-hub
    git-lfs
    git-imerge
    #    gitAndTools.git-octopus
    #    gitAndTools.git-open
    git-radar
    #    gitAndTools.git-recent
    #    git-remote-gcrypt
    git-subrepo
    git2cl
    gitflow
    gitFull
    hub
    qgit
    #    gitAndTools.stgit
    tig
    #    topgit
    transcrypt
    libgit2
  ];
}
