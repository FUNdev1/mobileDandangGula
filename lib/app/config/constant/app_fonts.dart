enum AppFont {
  ibmPlexMono,
  ibmPlexSans,
  inter,
  roboto,
  sfProDisplay,
  workSans,
}

// Extension untuk mendapatkan string nama font
extension AppFontExtension on AppFont {
  String get fontFamily {
    switch (this) {
      case AppFont.ibmPlexMono:
        return 'IBMPlexMono';
      case AppFont.ibmPlexSans:
        return 'IBMPlexSans';
      case AppFont.inter:
        return 'Inter';
      case AppFont.roboto:
        return 'Roboto';
      case AppFont.sfProDisplay:
        return 'SFProDisplay';
      case AppFont.workSans:
        return 'WorkSans';
    }
  }
}