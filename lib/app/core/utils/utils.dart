import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'constant/app_fonts.dart';
import 'constant/app_strings.dart';
import 'theme/app_colors.dart';

/// Utility class to manage font styles
class FontUtils {
  // Private constructor to prevent instantiation
  FontUtils._();

  /// Creates TextStyle with specified font attributes
  static TextStyle getFont({
    required AppFont font,
    double fontSize = 14.0,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
    FontStyle fontStyle = FontStyle.normal,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontFamily: font.fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? AppColors.textPrimary,
      fontStyle: fontStyle,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }
}

/// Utility class to format currency
class CurrencyFormatter {
  // Private constructor to prevent instantiation
  CurrencyFormatter._();

  /// Format number as Indonesian Rupiah
  static String formatRupiah(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  /// Format number with custom symbols and decimal places
  static String formatCurrency(
    double amount, {
    String symbol = '',
    int decimalDigits = 0,
    String locale = 'id_ID',
  }) {
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: decimalDigits,
    );
    return formatter.format(amount);
  }

  /// Format number with thousand separators
  static String formatThousands(double amount, {int decimalDigits = 0}) {
    final formatter = NumberFormat.decimalPattern('id_ID');
    formatter.minimumFractionDigits = 0;
    formatter.maximumFractionDigits = decimalDigits;
    return formatter.format(amount);
  }

  static String formatToShortK(double number) {
    // Bagi dengan 1000 untuk mendapatkan nilai dalam ribuan
    double inThousands = number / 1000;

    // Ambil dua digit pertama
    int twoDigits = inThousands.toInt();
    if (twoDigits >= 100) {
      twoDigits = (twoDigits ~/ 10); // Ambil puluhan jika nilai ribuan >= 100
    }

    // Tambahkan 'k' di belakang
    return '${twoDigits}k';
  }
}

/// Utility class to manage asset paths
class AssetUtils {
  // Private constructor to prevent instantiation
  AssetUtils._();

  // Base paths
  static const String _basePath = 'assets';
  static const String _imagesPath = '$_basePath/images';
  static const String _iconsPath = '$_basePath/icons';
}

/// Icon paths by category
class AppIcons {
  // Private constructor to prevent instantiation
  AppIcons._();

  // App logo
  static const String appIcon = '${AssetUtils._iconsPath}/app-icon.png';
  static const String logoDandangGula = '${AssetUtils._iconsPath}/logo-dandang-gula.png';

  // Navigation icons
  static const String arrowDown = '${AssetUtils._iconsPath}/arrow-down.svg';
  static const String arrowUp = '${AssetUtils._iconsPath}/arrow-up.svg';
  static const String arrowLeft = '${AssetUtils._iconsPath}/arrow-left.svg';
  static const String arrowRight = '${AssetUtils._iconsPath}/arrow-right.svg';
  static const String arrowDownLeft = '${AssetUtils._iconsPath}/arrow-down-left.svg';
  static const String arrowDownRight = '${AssetUtils._iconsPath}/arrow-down-right.svg';
  static const String arrowCounterClockwise = '${AssetUtils._iconsPath}/arrow-counter-clockwise.svg';

  // Carets
  static const String caretDown = '${AssetUtils._iconsPath}/caret-down.svg';
  static const String caretUp = '${AssetUtils._iconsPath}/caret-up.svg';
  static const String caretLeft = '${AssetUtils._iconsPath}/caret-left.svg';
  static const String caretRight = '${AssetUtils._iconsPath}/caret-right.svg';
  static const String caretSort = '${AssetUtils._iconsPath}/caret-sort.svg';

  // Action icons
  static const String add = '${AssetUtils._iconsPath}/add.svg';
  static const String minus = '${AssetUtils._iconsPath}/minus.svg';
  static const String search = '${AssetUtils._iconsPath}/magnifying.svg';
  static const String edit = '${AssetUtils._iconsPath}/edit.svg';
  static const String delete = '${AssetUtils._iconsPath}/delete.svg';
  static const String save = '${AssetUtils._iconsPath}/save.svg';
  static const String close = '${AssetUtils._iconsPath}/close.svg';
  static const String download = '${AssetUtils._iconsPath}/download.svg';
  static const String settings = '${AssetUtils._iconsPath}/settings.svg';
  static const String checkmark = '${AssetUtils._iconsPath}/checkmark.svg';
  static const String trashCan = '${AssetUtils._iconsPath}/trash-can.svg';

  // Main features
  static const String dashboard = '${AssetUtils._iconsPath}/dashboard.svg';
  static const String home = '${AssetUtils._iconsPath}/home.svg';
  static const String login = '${AssetUtils._iconsPath}/login.svg';
  static const String logout = '${AssetUtils._iconsPath}/logout.svg';
  static const String notification = '${AssetUtils._iconsPath}/notification-new.svg';
  static const String userAvatar = '${AssetUtils._iconsPath}/user-avatar.svg';
  static const String userAccess = '${AssetUtils._iconsPath}/user-access.svg';
  static const String customerService = '${AssetUtils._iconsPath}/customer-service.svg';

  // Business modules
  static const String orderDetails = '${AssetUtils._iconsPath}/order-details.svg';
  static const String restaurant = '${AssetUtils._iconsPath}/restaurant.svg';
  static const String shoppingBag = '${AssetUtils._iconsPath}/shopping-bag.svg';
  static const String shoppingCatalog = '${AssetUtils._iconsPath}/shopping-catalog.svg';
  static const String purchase = '${AssetUtils._iconsPath}/purchase.svg';
  static const String reportData = '${AssetUtils._iconsPath}/report-data.svg';
  static const String printer = '${AssetUtils._iconsPath}/printer.svg';
  static const String percentage = '${AssetUtils._iconsPath}/percentage.svg';
  static const String bottlesContainer = '${AssetUtils._iconsPath}/bottles-container.svg';
  static const String wheat = '${AssetUtils._iconsPath}/wheat.svg';
  static const String noodleBowl = '${AssetUtils._iconsPath}/noodle-bowl.svg';
  static const String dollar = '${AssetUtils._iconsPath}/dollar.svg';
  static const String edc = '${AssetUtils._iconsPath}/edc.svg';
  static const String qris = '${AssetUtils._iconsPath}/qris.svg';

  // UI related
  static const String viewFilled = '${AssetUtils._iconsPath}/view-filled.svg';
  static const String viewOffFilled = '${AssetUtils._iconsPath}/view-off-filled.svg';
  static const String splitScreen = '${AssetUtils._iconsPath}/split-screen.svg';
  static const String overflowMenuHorizontal = '${AssetUtils._iconsPath}/overflow-menu-horizontal.svg';
  static const String camera = '${AssetUtils._iconsPath}/camera.svg';

  // Calendar related
  static const String ibmGcm = '${AssetUtils._iconsPath}/ibm-gcm.svg';
  static const String calendarHeatMap = '${AssetUtils._iconsPath}/calendar-heat-map.svg';
  static const String calendarDot = '${AssetUtils._iconsPath}/calendar-dot.svg';
}

/// Image paths
class AppImages {
  // Private constructor to prevent instantiation
  AppImages._();

  static const String logo = '${AssetUtils._imagesPath}/logo.png';
  static const String background = '${AssetUtils._imagesPath}/background.png';
  static const String placeholder = '${AssetUtils._imagesPath}/placeholder.png';
  static const String loginBackground = '${AssetUtils._imagesPath}/login-background.png';
  static const String splashBackground = '${AssetUtils._imagesPath}/splash-background.png';
}

/// Extension to make asset path generation more flexible
extension AssetPathExtension on String {
  String get toIconPath => 'assets/icons/$this';
  String get toImagePath => 'assets/images/$this';
  String get toFontPath => 'assets/fonts/$this';

  String withIconExtension(String extension) => 'assets/icons/$this.$extension';
  String withImageExtension(String extension) => 'assets/images/$this.$extension';
}

/// Date formatting utilities
class DateFormatter {
  // Private constructor to prevent instantiation
  DateFormatter._();

  /// Format date to Indonesian format (dd MMMM yyyy)
  static String formatDateID(DateTime? date) {
    if (date == null) {
      return "";
    }
    return DateFormat('dd MMMM yyyy', 'id_ID').format(date.toLocal());
  }

  /// Format date with custom pattern
  static String formatDate(DateTime? date, {String pattern = 'dd/MM/yyyy'}) {
    if (date == null) {
      return "";
    }
    return DateFormat(pattern).format(date.toLocal());
  }

  /// Format date and time
  static String formatDateTime(DateTime? date) {
    if (date == null) {
      return "";
    }

    return DateFormat('dd/MM/yyyy HH:mm').format(date.toLocal());
  }
}

/// Validation utilities
class ValidationUtils {
  // Private constructor to prevent instantiation
  ValidationUtils._();

  /// Validate email address
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  /// Validate phone number (Indonesian format)
  static bool isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^(\+62|62|0)8[1-9][0-9]{6,9}$');
    return phoneRegex.hasMatch(phone);
  }
}

class ErrorMessages {
  static String getErrorMessage(dynamic error) {
    if (error == null) {
      return AppStrings.generalError;
    }

    final String errorString = error.toString().toLowerCase();

    if (errorString.contains('socket') || errorString.contains('connection refused')) {
      return AppStrings.noInternetError;
    } else if (errorString.contains('timeout')) {
      return AppStrings.timeoutError;
    } else if (errorString.contains('not found')) {
      return AppStrings.notFoundError;
    } else if (errorString.contains('server')) {
      return AppStrings.serverError;
    } else if (errorString.contains('validation')) {
      return AppStrings.validationError;
    } else if (errorString.contains('unauthorized') || errorString.contains('authentication')) {
      return AppStrings.authError;
    }

    return error.toString();
  }
}
