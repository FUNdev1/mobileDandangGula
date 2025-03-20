import 'package:flutter/material.dart';
import 'dart:math' as math;

class PaginatedResponse<T> {
  final List<T> data;
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  PaginatedResponse({
    required this.data,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });
}

class AppPagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;

  const AppPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Previous button
          _buildPaginationButton(
            label: 'Prev',
            isEnabled: currentPage > 1,
            onTap: () {
              if (currentPage > 1) {
                onPageChanged(currentPage - 1);
              }
            },
          ),

          const SizedBox(width: 8),

          // Page numbers
          ..._buildPageNumbers(),

          const SizedBox(width: 8),

          // Next button
          _buildPaginationButton(
            label: 'Next',
            isEnabled: currentPage < totalPages,
            onTap: () {
              if (currentPage < totalPages) {
                onPageChanged(currentPage + 1);
              }
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageNumbers() {
    List<Widget> pageWidgets = [];

    // Handle case when few pages
    if (totalPages <= 5) {
      for (int i = 1; i <= totalPages; i++) {
        pageWidgets.add(_buildPageButton(i));
      }
      return pageWidgets;
    }

    // Always show first page
    pageWidgets.add(_buildPageButton(1));

    // If current page is greater than 3, show ellipsis
    if (currentPage > 3) {
      pageWidgets.add(_buildEllipsis());
    }

    // Calculate range of visible page numbers
    int startPage = math.max(2, currentPage - 1);
    int endPage = math.min(totalPages - 1, currentPage + 1);

    // Adjust if current page is near the beginning or end
    if (currentPage <= 3) {
      endPage = math.min(4, totalPages - 1);
    } else if (currentPage >= totalPages - 2) {
      startPage = math.max(2, totalPages - 3);
    }

    // Add visible page numbers
    for (int i = startPage; i <= endPage; i++) {
      // Skip if it would be first or last page (we add those separately)
      if (i == 1 || i == totalPages) continue;
      pageWidgets.add(_buildPageButton(i));
    }

    // If current page is less than total pages - 2, show ellipsis
    if (currentPage < totalPages - 2) {
      pageWidgets.add(_buildEllipsis());
    }

    // Always show last page if more than one page
    if (totalPages > 1) {
      pageWidgets.add(_buildPageButton(totalPages));
    }

    return pageWidgets;
  }

  Widget _buildEllipsis() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        alignment: Alignment.center,
        child: const Text(
          '...',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildPageButton(int page) {
    final bool isSelected = page == currentPage;

    return GestureDetector(
      onTap: () {
        if (page != currentPage) {
          onPageChanged(page);
        }
      },
      child: Container(
        width: 32,
        height: 32,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF136C3A) : Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isSelected ? const Color(0xFF136C3A) : const Color(0xFFEAEEF2),
            width: 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          page.toString(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildPaginationButton({
    required String label,
    required bool isEnabled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isEnabled ? const Color(0xFFEAEEF2) : const Color(0xFFEEEEEE),
            width: 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isEnabled ? Colors.black : const Color(0xFFCCCCCC),
          ),
        ),
      ),
    );
  }
}
