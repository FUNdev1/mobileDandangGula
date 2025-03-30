import 'package:flutter/material.dart';
import '../../../../../config/theme/app_colors.dart';
import '../../../../../config/theme/app_text_styles.dart';

class TabItem {
  final String title;
  final Widget content;

  TabItem({
    required this.title,
    required this.content,
  });
}

class StockTabs extends StatefulWidget {
  final List<TabItem> tabs;
  final Function(int)? onTabChanged;
  final int initialIndex;

  const StockTabs({
    super.key,
    required this.tabs,
    this.onTabChanged,
    this.initialIndex = 0,
  });

  @override
  State<StockTabs> createState() => _StockTabsState();
}

class _StockTabsState extends State<StockTabs> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        if (widget.onTabChanged != null) {
          widget.onTabChanged!(_tabController.index);
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab headers
        Container(
          height: 48,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color(0xFFEAEEF2),
                width: 1,
              ),
            ),
          ),
          child: TabBar(
            controller: _tabController,
            tabs: widget.tabs.map((tab) => Tab(text: tab.title)).toList(),
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
          ),
        ),

        // Tab content - make sure this is expanded to fill available space
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.tabs.map((tab) => tab.content).toList(),
          ),
        ),
      ],
    );
  }
}
