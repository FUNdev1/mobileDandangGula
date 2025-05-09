import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF0D4927);
  static const Color secondary = Color(0xFF1B9851);
  static const Color accent = Color(0xFFE2B472);
  static const Color deepWiseBlue = Color(0xFF11373E);
  static const Color deepWiseGreen = Color(0xFF88DE7B);

  // Basic Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFFA8A8A8);
  static const Color darkGrey = Color(0xFFACACAC);
  static const Color black = Color(0xFF000000);
  static const Color black1 = Color(0xFF1A1A1A);
  static const Color darkGreen80 = Color(0xFF136C3A);

  // Background Colors
  static const Color background = Color(0xFFF4F4F4);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color disabledBackground = Color(0xFFF3F5F7);

  // Text Colors
  static const Color textPrimary = Color(0xFF111111);
  static const Color textSecondary = Color(0xFF474A4E);
  static const Color textTertiary = Color(0xFF808080);
  static const Color textTitleCard = Color(0xFFA9AEB2);
  static const Color textDisabled = Color(0xFFD5DBE0);

  // Border & Divider Colors
  static const Color border = Color(0xFFEAEEF2);
  static const Color borderTextField = Color(0xFFC1C1C1);
  static const Color divider = Color(0xFFF0F0F0);
  static const Color menuDivider = Color(0xFFEAEAEA);

  // Status Colors
  static const Color success = Color(0xFF1B9851);
  static const Color info = Color(0xFF017AEB);
  static const Color warning = Color(0xFFFFB200);
  static const Color error = Color(0xFFFF3B30);

  // Card Colors
  static const Color successLight = Color(0xFFDBF4D7);
  static const Color infoLight = Color(0xFFCFE8FF);
  static const Color warningLight = Color(0xFFFFF3D9);
  static const Color errorLight = Color(0xFFFFE5E5);

  // Icon Color
  static Color redCaretDown = const Color(0xB7FF0048);
  // Menghasilkan warna berdasarkan ID kategori
  static Color getColorFromId(String id) {
    // Menggunakan hash dari ID untuk menghasilkan warna yang konsisten
    final int hash = id.hashCode;

    // Menggunakan nilai hash untuk menghasilkan komponen warna RGB
    // Memastikan warna tidak terlalu gelap dengan menambahkan offset
    final int r = ((hash & 0xFF0000) >> 16) | 0x80; // Minimal 128 untuk red
    final int g = ((hash & 0x00FF00) >> 8) | 0x80; // Minimal 128 untuk green
    final int b = (hash & 0x0000FF) | 0x80; // Minimal 128 untuk blue

    return Color.fromARGB(255, r, g, b);
  }
}
