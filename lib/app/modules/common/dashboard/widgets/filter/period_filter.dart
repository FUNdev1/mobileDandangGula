import 'package:dandang_gula/app/global_widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'period_filter_controller.dart';

class PeriodFilter extends StatefulWidget {
  final PeriodFilterController controller;
  final List<Widget>? actionButton;
  final Function(String) onPeriodChanged;

  const PeriodFilter({
    super.key,
    required this.controller,
    this.actionButton,
    required this.onPeriodChanged,
  });

  @override
  State<PeriodFilter> createState() => _PeriodFilterState();
}

class _PeriodFilterState extends State<PeriodFilter> {
  // Overlay entries for dropdown and calendar
  OverlayEntry? _dropdownOverlay;
  OverlayEntry? _calendarOverlay;

  // Layer links for positioning
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _removeDropdownOverlay();
    _removeCalendarOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return CompositedTransformTarget(
        link: _layerLink,
        child: Container(
          width: double.infinity,
          height: 68,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              // Main filter button
              InkWell(
                onTap: () {
                  if (widget.controller.isDropdownOpen.value) {
                    _removeDropdownOverlay();
                  } else {
                    _showDropdownOverlay();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFD5DBE0)),
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.transparent,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Periode Data',
                        style: TextStyle(
                          fontFamily: 'Work Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF474A4E),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        _getPeriodName(widget.controller.selectedPeriod.value),
                        style: const TextStyle(
                          fontFamily: 'Work Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF474A4E),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          widget.controller.formattedDateRange.value,
                          style: const TextStyle(
                            fontFamily: 'Work Sans',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF474A4E),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: () {
                          _showDropdownOverlay();
                        },
                        child: const Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: Color(0xFFD5DBE0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (widget.actionButton != null && (widget.actionButton ?? []).isNotEmpty) ...widget.actionButton!
            ],
          ),
        ),
      );
    });
  }

  // Show dropdown overlay
  void _showDropdownOverlay() {
    _removeCalendarOverlay();

    _dropdownOverlay = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _removeDropdownOverlay,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: Colors.transparent,
              ),
            ),
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: const Offset(0, 38),
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(4),
                child: GestureDetector(
                  onTap: () {}, // Prevent tap through
                  child: _buildDropdownContent(),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_dropdownOverlay!);
    widget.controller.isDropdownOpen.value = true;

    // Debug - verify overlay is created
    debugPrint('Dropdown overlay shown');
  }

  // Show calendar overlay
  void _showCalendarOverlay(String mode) {
    _removeDropdownOverlay();

    // Set calendar mode
    widget.controller.calendarMode.value = mode;

    // Initialize calendar view with current filter date
    widget.controller.calendarViewDate.value = widget.controller.startDate.value;
    widget.controller.selectedCalendarDate.value = widget.controller.startDate.value;

    // Set temporary date for preview - we'll only apply this if user clicks "Apply"
    widget.controller.tempStartDate.value = widget.controller.startDate.value;
    widget.controller.tempEndDate.value = widget.controller.endDate.value;

    _calendarOverlay = OverlayEntry(
      builder: (context) => Obx(() => GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _removeCalendarOverlay,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
                CompositedTransformFollower(
                  link: _layerLink,
                  showWhenUnlinked: false,
                  offset: const Offset(0, 38),
                  child: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(4),
                    child: GestureDetector(
                      onTap: () {}, // Prevent tap through
                      child: _buildInlineCalendar(),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );

    Overlay.of(context).insert(_calendarOverlay!);
    widget.controller.isCalendarVisible.value = true;

    // Debug - verify overlay is created
    debugPrint('Calendar overlay shown for mode: $mode');
  }

  // Remove dropdown overlay
  void _removeDropdownOverlay() {
    _dropdownOverlay?.remove();
    _dropdownOverlay = null;
    widget.controller.isDropdownOpen.value = false;
  }

  // Remove calendar overlay
  void _removeCalendarOverlay() {
    _calendarOverlay?.remove();
    _calendarOverlay = null;
    widget.controller.isCalendarVisible.value = false;
  }

  // Build dropdown content
  Widget _buildDropdownContent() {
    final List<Map<String, dynamic>> periods = [
      {'id': 'real-time', 'name': 'Real-time', 'display': 'Hari ini'},
      {'id': 'kemarin', 'name': 'Kemarin', 'display': 'Kemarin'},
      {'id': '7-hari', 'name': '7 hari sebelumnya', 'display': '7 hari terakhir'},
      {'id': '30-hari', 'name': '30 hari sebelumnya', 'display': '30 hari terakhir'},
      {'id': 'per-hari', 'name': 'Per Hari', 'display': 'Data harian', 'needsDatePicker': true},
      {'id': 'per-minggu', 'name': 'Per Minggu', 'display': 'Data mingguan', 'needsDatePicker': true},
      {'id': 'per-bulan', 'name': 'Per Bulan', 'display': 'Data bulanan', 'needsDatePicker': true},
    ];

    return Obx(() {
      return Container(
        width: 409, // Fixed width from design
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: periods.map((period) {
            final bool isSelected = widget.controller.selectedPeriod.value == period['id'];
            final bool needsDatePicker = period['needsDatePicker'] == true;

            return InkWell(
              onTap: () {
                if (needsDatePicker) {
                  // Just show the calendar for date selection
                  // We'll only apply the period if user clicks "Apply" in calendar
                  _removeDropdownOverlay();
                  _showCalendarOverlay(period['id']);
                } else {
                  // For direct periods, apply immediately
                  widget.controller.changePeriod(period['id']);
                  widget.onPeriodChanged(period['id']);
                  _removeDropdownOverlay();
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFEAEEF2) : Colors.white,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text(
                        period['name'],
                        style: TextStyle(
                          fontFamily: 'Work Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.56,
                          color: isSelected ? const Color(0xFF21776A) : Colors.black,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Expanded(
                        child: Text(
                          // For selected periods, show full date range
                          getDateRangeDisplay(period['id']),
                          style: const TextStyle(
                            fontFamily: 'Work Sans',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.56,
                            color: Color(0xFF21776A),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    if (needsDatePicker)
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: isSelected ? const Color(0xFF21776A) : Colors.grey,
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      );
    });
  }

  // Get date range display for selected period
  String getDateRangeDisplay(String periodId) {
    final DateFormat shortFormat = DateFormat('d MMM yyyy');

    switch (periodId) {
      case 'real-time':
        return 'Hari ini - ${DateFormat('HH:mm').format(DateTime.now())} (GMT+07)';
      case 'kemarin':
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        return shortFormat.format(yesterday);
      case '7-hari':
        final endDate = DateTime.now();
        final startDate = endDate.subtract(const Duration(days: 6)); // 7 hari termasuk hari ini
        return '${shortFormat.format(startDate)} - ${shortFormat.format(endDate)}';
      case '30-hari':
        final endDate = DateTime.now();
        final startDate = endDate.subtract(const Duration(days: 29)); // 30 hari termasuk hari ini
        return '${shortFormat.format(startDate)} - ${shortFormat.format(endDate)}';
      default:
        // For per-hari, per-minggu, per-bulan, show actual date range from controller
        if (periodId == 'per-hari') {
          return shortFormat.format(widget.controller.startDate.value);
        } else {
          return '${shortFormat.format(widget.controller.startDate.value)} - ${shortFormat.format(widget.controller.endDate.value)}';
        }
    }
  }

  // Build inline calendar
  Widget _buildInlineCalendar() {
    // Get current view month/year
    final DateTime viewDate = widget.controller.calendarViewDate.value;
    final String monthYearText = DateFormat('MMMM yyyy').format(viewDate);

    // Update calendar title and instructions based on mode
    String calendarTitle = 'Pilih Tanggal';
    String calendarInstruction = '';

    switch (widget.controller.calendarMode.value) {
      case 'per-hari':
        calendarTitle = 'Pilih Tanggal';
        calendarInstruction = 'Pilih tanggal untuk melihat data harian';
        break;
      case 'per-minggu':
        calendarTitle = 'Pilih Minggu';
        calendarInstruction = 'Pilih tanggal awal minggu (Senin)';
        break;
      case 'per-bulan':
        calendarTitle = 'Pilih Bulan';
        calendarInstruction = 'Pilih tanggal dalam bulan yang diinginkan';
        break;
      case 'custom-date':
        calendarTitle = 'Pilih Tanggal Kustom';
        calendarInstruction = 'Pilih tanggal spesifik';
        break;
    }

    // Calculate preview date range based on selected date
    String previewDateRange = _calculatePreviewDateRange();

    return Container(
      width: 409, // Fixed width from design
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calendar title and instructions
            Text(
              calendarTitle,
              style: const TextStyle(
                fontFamily: 'Work Sans',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (calendarInstruction.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  calendarInstruction,
                  style: const TextStyle(
                    fontFamily: 'Work Sans',
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Preview of selected date range
            if (previewDateRange.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 16, color: Color(0xFF136C3A)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Rentang: $previewDateRange',
                        style: const TextStyle(
                          fontFamily: 'Work Sans',
                          fontSize: 12,
                          color: Color(0xFF136C3A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            // Month and year selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, size: 20),
                  onPressed: () => _navigateCalendar(-1),
                ),
                Text(
                  monthYearText,
                  style: const TextStyle(
                    fontFamily: 'Work Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, size: 20),
                  onPressed: () => _navigateCalendar(1),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Weekday headers
            Row(
              children: const ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((day) {
                return Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: const TextStyle(
                        fontFamily: 'Work Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF474A4E),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 4),

            // Calendar days grid
            ..._buildCalendarGrid(),

            const SizedBox(height: 16),

            // Apply button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _removeCalendarOverlay,
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontFamily: 'Work Sans',
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // Apply the selected date based on calendar mode
                    final selectedDate = widget.controller.selectedCalendarDate.value;

                    switch (widget.controller.calendarMode.value) {
                      case 'per-hari':
                        widget.controller.setPeriodSpecificDate('per-hari', selectedDate);
                        break;
                      case 'per-minggu':
                        widget.controller.setPeriodSpecificDate('per-minggu', selectedDate);
                        break;
                      case 'per-bulan':
                        widget.controller.setPeriodSpecificDate('per-bulan', selectedDate);
                        break;
                      case 'custom-date':
                        widget.controller.setCustomDateRange(selectedDate);
                        break;
                    }

                    _removeCalendarOverlay();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF136C3A),
                  ),
                  child: const Text(
                    'Apply',
                    style: TextStyle(
                      fontFamily: 'Work Sans',
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Calculate preview date range based on selected date and mode
  String _calculatePreviewDateRange() {
    final DateFormat shortFormat = DateFormat('d MMM yyyy');
    final selectedDate = widget.controller.selectedCalendarDate.value;

    switch (widget.controller.calendarMode.value) {
      case 'per-hari':
        // Just the selected day
        return shortFormat.format(selectedDate);

      case 'per-minggu':
        // Calculate the Monday of the week
        final int weekday = selectedDate.weekday;
        final mondayOfThisWeek = selectedDate.subtract(Duration(days: weekday - 1));
        final sundayOfThisWeek = mondayOfThisWeek.add(const Duration(days: 6));

        return '${shortFormat.format(mondayOfThisWeek)} - ${shortFormat.format(sundayOfThisWeek)}';

      case 'per-bulan':
        // First day to last day of month
        final firstDay = DateTime(selectedDate.year, selectedDate.month, 1);
        final lastDay = (selectedDate.month < 12) ? DateTime(selectedDate.year, selectedDate.month + 1, 0) : DateTime(selectedDate.year + 1, 1, 0);

        return '${shortFormat.format(firstDay)} - ${shortFormat.format(lastDay)}';

      case 'custom-date':
        // Just the selected day
        return shortFormat.format(selectedDate);

      default:
        return '';
    }
  }

  // Build calendar grid
  List<Widget> _buildCalendarGrid() {
    final DateTime viewDate = widget.controller.calendarViewDate.value;
    final DateTime selectedDate = widget.controller.selectedCalendarDate.value;

    // Calculate first day of the month
    final DateTime firstDayOfMonth = DateTime(viewDate.year, viewDate.month, 1);

    // Get the weekday (1-7, where 1 is Monday)
    int startWeekday = firstDayOfMonth.weekday;

    // Calculate number of days in the month
    final DateTime lastDayOfMonth = (viewDate.month < 12) ? DateTime(viewDate.year, viewDate.month + 1, 0) : DateTime(viewDate.year + 1, 1, 0);
    final int daysInMonth = lastDayOfMonth.day;

    // Calculate number of weeks needed
    final int totalCells = startWeekday - 1 + daysInMonth;
    final int totalRows = (totalCells / 7).ceil();

    List<Widget> rows = [];

    // Create calendar rows
    int day = 1 - (startWeekday - 1);

    for (int week = 0; week < totalRows; week++) {
      List<Widget> weekCells = [];

      for (int weekday = 0; weekday < 7; weekday++) {
        if (day > 0 && day <= daysInMonth) {
          // Current month day
          final DateTime cellDate = DateTime(viewDate.year, viewDate.month, day);
          final bool isSelected = _isSameDay(cellDate, selectedDate);
          final bool isToday = _isSameDay(cellDate, DateTime.now());

          // For per-minggu mode, highlight Monday cells
          bool isSpecialDay = false;
          if (widget.controller.calendarMode.value == 'per-minggu' && weekday == 0) {
            isSpecialDay = true;
          }

          weekCells.add(
            Expanded(
              child: InkWell(
                  onTap: () {
                    // Update selected date
                    widget.controller.selectedCalendarDate.value = cellDate;

                    // Update preview dates based on mode
                    _updatePreviewDates(cellDate);

                    // Force refresh UI
                    widget.controller.update();
                  },
                  child: Container(
                    height: 36,
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF136C3A)
                          : isToday
                              ? const Color(0xFFE8F5E9)
                              : isSpecialDay
                                  ? const Color(0xFFF5F5F5)
                                  : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                      // Tambahkan border lebih tebal untuk tanggal terpilih
                      border: isSelected
                          ? Border.all(color: const Color(0xFF0A4D2D), width: 2)
                          : isToday && !isSelected
                              ? Border.all(color: const Color(0xFF136C3A))
                              : isSpecialDay && !isSelected
                                  ? Border.all(color: Colors.grey.shade300)
                                  : null,
                    ),
                    alignment: Alignment.center,
                    // Bisa juga menambahkan stack untuk ikon centang di sudut
                    child: isSelected
                        ? Stack(
                            children: [
                              Center(
                                child: Text(
                                  day.toString(),
                                  style: const TextStyle(
                                    fontFamily: 'Work Sans',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const Positioned(
                                right: 2,
                                bottom: 2,
                                child: Icon(
                                  Icons.check_circle,
                                  size: 10,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            day.toString(),
                            style: const TextStyle(
                              fontFamily: 'Work Sans',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF474A4E),
                            ),
                          ),
                  )),
            ),
          );
        } else {
          // Previous or next month day (empty or grayed out)
          weekCells.add(
            Expanded(
              child: Container(
                height: 36,
                margin: const EdgeInsets.all(2),
              ),
            ),
          );
        }
        day++;
      }

      rows.add(
        Row(children: weekCells),
      );
    }

    return rows;
  }

  // Update preview dates based on selected date and mode
  void _updatePreviewDates(DateTime selectedDate) {
    switch (widget.controller.calendarMode.value) {
      case 'per-hari':
        widget.controller.tempStartDate.value = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
        widget.controller.tempEndDate.value = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 23, 59, 59);
        break;

      case 'per-minggu':
        // Calculate the Monday of the week
        final int weekday = selectedDate.weekday;
        final mondayOfThisWeek = selectedDate.subtract(Duration(days: weekday - 1));

        widget.controller.tempStartDate.value = DateTime(mondayOfThisWeek.year, mondayOfThisWeek.month, mondayOfThisWeek.day);
        widget.controller.tempEndDate.value = widget.controller.tempStartDate.value.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
        break;

      case 'per-bulan':
        // First day to last day of month
        widget.controller.tempStartDate.value = DateTime(selectedDate.year, selectedDate.month, 1);

        // Find the last day of the month
        final lastDay = (selectedDate.month < 12) ? DateTime(selectedDate.year, selectedDate.month + 1, 0) : DateTime(selectedDate.year + 1, 1, 0);

        widget.controller.tempEndDate.value = DateTime(lastDay.year, lastDay.month, lastDay.day, 23, 59, 59);
        break;

      case 'custom-date':
        widget.controller.tempStartDate.value = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
        widget.controller.tempEndDate.value = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 23, 59, 59);
        break;
    }

    // Force refresh after updating dates
    widget.controller.update();
  }

  // Check if two dates are the same day
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // Navigate calendar by months
  void _navigateCalendar(int months) {
    final DateTime current = widget.controller.calendarViewDate.value;
    if (months > 0) {
      // Navigate forward
      widget.controller.calendarViewDate.value = DateTime(
        current.month < 12 ? current.year : current.year + 1,
        current.month < 12 ? current.month + 1 : 1,
      );
    } else {
      // Navigate backward
      widget.controller.calendarViewDate.value = DateTime(
        current.month > 1 ? current.year : current.year - 1,
        current.month > 1 ? current.month - 1 : 12,
      );
    }

    // Force refresh of the controller
    widget.controller.update();
  }

  // Get period name for display
  String _getPeriodName(String periodId) {
    switch (periodId) {
      case 'real-time':
        return 'Real-time';
      case 'kemarin':
        return 'Kemarin';
      case '7-hari':
        return '7 hari sebelumnya';
      case '30-hari':
        return '30 hari sebelumnya';
      case 'per-hari':
        return 'Per Hari';
      case 'per-minggu':
        return 'Per Minggu';
      case 'per-bulan':
        return 'Per Bulan';
      default:
        return 'Real-time';
    }
  }
}
