self: super:
let
  unstable = builtins.fetchTarball {
    url =
      "https://github.com/nixos/nixpkgs-channels/archive/nixos-unstable.tar.gz";
    sha256 = "sha256:1sidky93vc2bpnwb8avqlym1p70h2szhkfiam549377v9r5ld2r1";
  };
in {
  emacsWithPackages = (import unstable { }).emacsWithPackages;
  emacs = (import unstable { }).emacs;
  #        emacsGcc = (import unstable { }).emacsGcc;
}
