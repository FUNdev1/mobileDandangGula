import 'package:flutter/material.dart';
import '../../../../../config/theme/app_colors.dart';
import '../../../../../config/theme/app_text_styles.dart';
import '../../../../../global_widgets/layout/tab_container.dart';

class StockTabs extends StatelessWidget {
  final List<TabItem> tabs;
  final Function(int) onTabChanged;

  const StockTabs({
    super.key,
    required this.tabs,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Tab navigation
          Container(
            height: 52,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.border),
              ),
            ),
            child: Row(
              children: List.generate(
                tabs.length,
                (index) => _buildTabItem(
                  tabs[index].title,
                  index == 0, // First tab is active by default
                  () => onTabChanged(index),
                ),
              ),
            ),
          ),

          // Tab content
          Expanded(
            child: TabContainer(
              tabs: tabs,
              onTabChanged: onTabChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, bool isActive, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        height: 52,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? const Color(0xFF88DE7B) : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isActive ? const Color(0xFF1B9851) : AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
