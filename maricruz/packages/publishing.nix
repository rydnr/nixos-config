{ config, lib, pkgs, ... }:
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    aspell
    aspellDicts.en
    aspellDicts.es
    bundler
    calibre
    cups
    dia
    ditaa
    evince
    ghostscript
    ghostscriptX
    graphviz
    hugo
    jekyll
    mdp
    pandoc
    python3Packages.pygments
    python3Packages.sphinx
#    scribusUnstable
    xournal
#    yacreader
#    xpdf
    zotero
  ];
}
