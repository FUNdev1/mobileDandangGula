import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PeriodFilterController extends GetxController {
  // Selected period identifier
  final RxString selectedPeriod = 'real-time'.obs;

  // Observable date range
  final Rx<DateTime> startDate = DateTime.now().obs;
  final Rx<DateTime> endDate = DateTime.now().obs;

  // Temporary date range for preview
  final Rx<DateTime> tempStartDate = DateTime.now().obs;
  final Rx<DateTime> tempEndDate = DateTime.now().obs;

  // Observable formatted date for display
  final RxString formattedDateRange = ''.obs;

  // Dropdown state
  final RxBool isDropdownOpen = false.obs;

  // Calendar state
  final RxBool isCalendarVisible = false.obs;
  final RxString calendarMode = ''.obs;
  final Rx<DateTime> calendarViewDate = DateTime.now().obs;
  final Rx<DateTime> selectedCalendarDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with default period (real-time = today)
    updateDateRange('real-time');
    updateFormattedDateRange();
  }

  // Update the period and recalculate date range
  void changePeriod(String periodId) {
    selectedPeriod.value = periodId;
    updateDateRange(periodId);
    updateFormattedDateRange();
  }

  // Set custom date range for a specific date
  void setCustomDateRange(DateTime date) {
    startDate.value = DateTime(date.year, date.month, date.day);
    endDate.value = DateTime(date.year, date.month, date.day, 23, 59, 59);
    selectedPeriod.value = 'custom-date';
    updateFormattedDateRange();
  }

  // Set period specific date (for per-hari, per-minggu, per-bulan)
  void setPeriodSpecificDate(String periodId, DateTime date) {
    selectedPeriod.value = periodId;

    switch (periodId) {
      case 'per-hari':
        // Set date range for the specific day
        startDate.value = DateTime(date.year, date.month, date.day);
        endDate.value = DateTime(date.year, date.month, date.day, 23, 59, 59);
        break;

      case 'per-minggu':
        // Set date range for the week starting from the selected date
        // Find the Monday of the week
        final int weekday = date.weekday;
        final mondayOfThisWeek = date.subtract(Duration(days: weekday - 1));

        startDate.value = DateTime(mondayOfThisWeek.year, mondayOfThisWeek.month, mondayOfThisWeek.day);
        endDate.value = startDate.value.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
        break;

      case 'per-bulan':
        // Set date range for the selected month
        startDate.value = DateTime(date.year, date.month, 1);
        // Find the last day of the month
        final lastDay = (date.month < 12) ? DateTime(date.year, date.month + 1, 0) : DateTime(date.year + 1, 1, 0);
        endDate.value = DateTime(lastDay.year, lastDay.month, lastDay.day, 23, 59, 59);
        break;
    }

    updateFormattedDateRange();
  }

  // Update the date range based on period ID
  void updateDateRange(String periodId) {
    final now = DateTime.now();

    switch (periodId) {
      case 'real-time':
        // Today
        startDate.value = DateTime(now.year, now.month, now.day);
        endDate.value = now;
        break;

      case 'kemarin':
        // Yesterday
        final yesterday = now.subtract(const Duration(days: 1));
        startDate.value = DateTime(yesterday.year, yesterday.month, yesterday.day);
        endDate.value = DateTime(yesterday.year, yesterday.month, yesterday.day, 23, 59, 59);
        break;

      case '7-hari':
        // Last 7 days
        endDate.value = now;
        startDate.value = now.subtract(const Duration(days: 6)); // 7 days including today
        break;

      case '30-hari':
        // Last 30 days
        endDate.value = now;
        startDate.value = now.subtract(const Duration(days: 29)); // 30 days including today
        break;

      case 'per-hari':
        // Current day by default
        startDate.value = DateTime(now.year, now.month, now.day);
        endDate.value = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;

      case 'per-minggu':
        // Current week starting from Monday
        final weekday = now.weekday;
        final mondayOfThisWeek = now.subtract(Duration(days: weekday - 1));
        startDate.value = DateTime(mondayOfThisWeek.year, mondayOfThisWeek.month, mondayOfThisWeek.day);
        endDate.value = startDate.value.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
        break;

      case 'per-bulan':
        // Current month
        startDate.value = DateTime(now.year, now.month, 1);
        // Find the last day of the month
        final lastDay = (now.month < 12) ? DateTime(now.year, now.month + 1, 0) : DateTime(now.year + 1, 1, 0);
        endDate.value = DateTime(lastDay.year, lastDay.month, lastDay.day, 23, 59, 59);
        break;

      case 'custom-date':
        // Don't change existing date range
        break;

      default:
        // Default to today
        startDate.value = DateTime(now.year, now.month, now.day);
        endDate.value = now;
    }
  }

  // Update formatted date range for display
  void updateFormattedDateRange() {
    final DateFormat shortFormat = DateFormat('d MMM yyyy');

    if (selectedPeriod.value == 'per-hari' || selectedPeriod.value == 'custom-date') {
      formattedDateRange.value = shortFormat.format(startDate.value);
      return;
    } else {
      formattedDateRange.value = '${shortFormat.format(startDate.value)} - ${shortFormat.format(endDate.value)}';
    }

    switch (selectedPeriod.value) {
      case 'real-time':
        formattedDateRange.value = 'Hari ini - ${DateFormat('HH:mm').format(DateTime.now())} (GMT+07)';
        break;

      case 'kemarin':
        formattedDateRange.value = shortFormat.format(startDate.value);
        break;

      case '7-hari':
      case '30-hari':
      case 'per-minggu':
      case 'per-bulan':
        formattedDateRange.value = '${shortFormat.format(startDate.value)} - ${shortFormat.format(endDate.value)}';
        break;

      case 'per-hari':
        formattedDateRange.value = shortFormat.format(startDate.value);
        break;

      default:
        formattedDateRange.value = '';
    }
  }

  // Get filter parameters for API calls
  Map<String, dynamic> getFilterParams() {
    return {
      'period_type': selectedPeriod.value,
      'start_date': DateFormat('yyyy-MM-dd').format(startDate.value),
      'end_date': DateFormat('yyyy-MM-dd').format(endDate.value),
    };
  }
}
