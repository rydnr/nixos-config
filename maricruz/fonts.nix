{ config, lib, pkgs, ... }: {
  fonts = {
    fontDir.enable = true;
    enableDefaultPackages = true;
    enableGhostscriptFonts = true;
    packages = with pkgs; [
      cantarell-fonts
      corefonts
      dejavu_fonts
      dina-font
      dosemu_fonts
      emacs-all-the-icons-fonts
      et-book
      fira-code
      fira-code-symbols
      font-awesome
      fontconfig
      fontforge
      fontforge-gtk
      # fontmatrix
      freefont_ttf
      gohufont
      google-fonts
      gyre-fonts
      hack-font
      inconsolata
      ipaexfont
      ipafont
      kawkab-mono-font
      liberation_ttf
      lohit-fonts.assamese
      lohit-fonts.bengali
      lohit-fonts.devanagari
      lohit-fonts.gujarati
      lohit-fonts.gurmukhi
      lohit-fonts.kannada
      lohit-fonts.kashmiri
      lohit-fonts.konkani
      lohit-fonts.maithili
      lohit-fonts.malayalam
      lohit-fonts.marathi
      lohit-fonts.nepali
      lohit-fonts.odia
      lohit-fonts.sindhi
      lohit-fonts.tamil
      lohit-fonts.tamil-classical
      lohit-fonts.telugu
      # mplus-outline-fonts
      # 404            nerdfonts
      ocamlPackages.fontconfig
      #            perlPackages.FontAFM
      #            perlPackages.FontTTF
      powerline-fonts
      proggyfonts
      rxvt-unicode-plugins.font-size
      soundfont-fluid
      source-code-pro
      source-sans-pro
      source-serif-pro
      terminus_font
      # tewi-font
      # 404
      #           textfonts
      ttmkfdir
      ubuntu-classic
      ucs-fonts
      unifont
      unifont_upper
      # broken    vistafonts
      xfontsel
      xlsfonts
      font-adobe-100dpi
      font-adobe-75dpi
      font-adobe-utopia-100dpi
      font-adobe-utopia-75dpi
      font-adobe-utopia-type1
      font-alias
      font-arabic-misc
      font-bh-100dpi
      font-bh-75dpi
      font-bh-lucidatypewriter-100dpi
      font-bh-lucidatypewriter-75dpi
      font-bh-ttf
      font-bh-type1
      font-bitstream-100dpi
      font-bitstream-100dpi
      font-bitstream-75dpi
      font-bitstream-type1
      font-cronyx-cyrillic
      font-cursor-misc
      font-daewoo-misc
      font-dec-misc
      font-ibm-type1
      font-isas-misc
      font-jis-misc
      font-micro-misc
      font-misc-cyrillic
      font-misc-ethiopic
      font-misc-meltho
      font-misc-misc
      font-mutt-misc
      font-schumacher-misc
      font-screen-cyrillic
      font-sony-misc
      font-sun-misc
      font-util
      font-winitzki-cyrillic
      font-xfree86-type1
      libfontenc
      libxfont_1
      libxfont_2
      mkfontscale
    ];
  };
  # bigger tty fonts
  console.font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "1";
    #        _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  };
}
