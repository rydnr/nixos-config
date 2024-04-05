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
      dina-font-pcf
      dosemu_fonts
      emacs-all-the-icons-fonts
      etBook
      fira-code
      fira-code-symbols
      font-awesome
      fontconfig
      fontforge
      fontforge-gtk
      fontmatrix
      freefont_ttf
      gnome3.gnome-font-viewer
      gohufont
      google-fonts
      gtk2fontsel
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
      soundfont-fluid
      source-code-pro
      source-sans-pro
      source-serif-pro
      terminus_font
      tewi-font
      # 404
      #           textfonts
      ttmkfdir
      ubuntu_font_family
      ucs-fonts
      unifont
      unifont_upper
      urxvt_font_size
      # broken    vistafonts
      xfontsel
      xlsfonts
      xorg.fontadobe100dpi
      xorg.fontadobe75dpi
      xorg.fontadobeutopia100dpi
      xorg.fontadobeutopia75dpi
      xorg.fontadobeutopiatype1
      xorg.fontalias
      xorg.fontarabicmisc
      xorg.fontbh100dpi
      xorg.fontbh75dpi
      xorg.fontbhlucidatypewriter100dpi
      xorg.fontbhlucidatypewriter75dpi
      xorg.fontbhttf
      xorg.fontbhtype1
      xorg.fontbitstream100dpi
      xorg.fontbitstream100dpi
      xorg.fontbitstream75dpi
      xorg.fontbitstreamtype1
      xorg.fontcronyxcyrillic
      xorg.fontcursormisc
      xorg.fontdaewoomisc
      xorg.fontdecmisc
      xorg.fontibmtype1
      xorg.fontisasmisc
      xorg.fontjismisc
      xorg.fontmicromisc
      xorg.fontmisccyrillic
      xorg.fontmiscethiopic
      xorg.fontmiscmeltho
      xorg.fontmiscmisc
      xorg.fontmuttmisc
      xorg.fontschumachermisc
      xorg.fontscreencyrillic
      xorg.fontsonymisc
      xorg.fontsunmisc
      xorg.fontutil
      xorg.fontwinitzkicyrillic
      xorg.fontxfree86type1
      xorg.libfontenc
      xorg.libXfont
      xorg.libXfont2
      xorg.mkfontdir
      xorg.mkfontscale
    ];
  };
  # bigger tty fonts
  console.font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
    #        _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  };
}
