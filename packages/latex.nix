{ config, lib, pkgs, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs;
    [
      (texlive.combine {
        inherit (texlive)
          algorithms collection-basic
          # infinite recursion        collection-context
          collection-fontsrecommended collection-fontutils collection-humanities
          collection-langenglish collection-langspanish collection-latex
          collection-latexextra collection-latexrecommended collection-luatex
          collection-metapost collection-pictures collection-pstricks
          collection-publishers fancyhdr minted pdftex pdftricks pdftricks2
          pstricks scheme-full tcolorbox tikzinclude tikzsymbols tikzscale;
      })
    ];
}
