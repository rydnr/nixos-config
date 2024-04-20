{ config, lib, pkgs, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    conda
    # poetry2nix
    #    python
    python3
    python3Packages.beautifulsoup4
    python3Packages.black
    #    python3Packages.conda
    python3Packages.editorconfig
    python3Packages.isort
    python3Packages.jsbeautifier
    python3Packages.jsondiff
    python3Packages.Keras
    python3Packages.nose
    python3Packages.pip
    pipenv
    poetry
    python3Packages.powerline
    # python3Packages.pyenv
    python3Packages.pyflakes
    python3Packages.pytest
    #    python38Packages.python-language-server
    python3Packages.python-lsp-server
    #    python3Packages.rpkg
    #    python3Packages.scikitlearn
    #    python3Packages.scrapy
    #    python3Packages.svg2tikz
    python3Packages.virtualenv
  ];
}

