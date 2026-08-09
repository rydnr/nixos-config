{ config, lib, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    ((emacsPackagesFor emacs).emacsWithPackages (epkgs:
      with epkgs; [
        melpaStablePackages.pdf-tools
        proof-general
        vterm
        #        exwm
        emacsql
        #        emacsql-sqlite
        pkgs.libvterm
        pkgs.clang-tools
      ]))
    discount
    jetbrains.goland
    # jetbrains.pycharm-professional
    leo-editor
    vim
    vscode
  ];

  # nixpkgs.overlays = [
  #    (self: super:
  #      let unstable = builtins.fetchTarball https://github.com/nixos/nixpkgs-channels/archive/nixos-unstable.tar.gz; in {
  #        emacs = (import unstable { }).emacs;
  #      }
  #    )
  #  ];
}
