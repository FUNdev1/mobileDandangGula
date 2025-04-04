import 'package:flutter/material.dart';

// Enum untuk tipe desain tab
enum TabDesignType {
  elevated, // Desain dengan tab bergaya elevated (default seperti TabContainer asli)
  underline, // Desain dengan garis bawah (seperti pada screenshot)
}

class TabItem {
  final String title;
  final Widget content;

  TabItem({
    required this.title,
    required this.content,
  });
}

class TabContainer extends StatefulWidget {
  final List<TabItem> tabs;
  final Color activeTabColor;
  final Color inactiveTabColor;
  final Color backgroundColor;
  final double height;
  final double tabHeight;
  final double borderRadius;
  final ValueChanged<int>? onTabChanged;
  final int initialIndex;
  final TabDesignType designType; // Tambahkan parameter designType

  const TabContainer({
    super.key,
    required this.tabs,
    this.activeTabColor = const Color(0xFF0C4123),
    this.inactiveTabColor = const Color(0x730C4123), // 45% opacity
    this.backgroundColor = const Color(0xFFECECEC), // Matching your design
    this.height = 600,
    this.tabHeight = 60, // Increased to match your design
    this.borderRadius = 16,
    this.onTabChanged,
    this.initialIndex = 0,
    this.designType = TabDesignType.elevated, // Default ke desain elevated original
  });

  @override
  State<TabContainer> createState() => _TabContainerState();
}

class _TabContainerState extends State<TabContainer> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _tabController = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _currentIndex = _tabController.index;
        });
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
    // Gunakan desain yang berbeda berdasarkan tipe desain
    return Column(
      children: [
        // Tab header dengan desain berbeda sesuai enum type
        widget.designType == TabDesignType.elevated ? _buildElevatedTabBar() : _buildUnderlineTabBar(),

        const SizedBox(height: 16),

        // Tab content dengan animasi untuk transisi halus
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: KeyedSubtree(
            key: ValueKey<int>(_currentIndex),
            child: widget.tabs[_currentIndex].content,
          ),
        ),
      ],
    );
  }

  // Desain tab asli (elevated)
  Widget _buildElevatedTabBar() {
    return Container(
      width: double.infinity,
      height: widget.tabHeight,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: Row(
        children: widget.tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = index == _currentIndex;

          return GestureDetector(
            onTap: () {
              _tabController.animateTo(index);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(8), // Using 8px from design
                boxShadow: isSelected
                    ? const [
                        BoxShadow(
                          color: Color.fromRGBO(152, 152, 152, 0.12),
                          blurRadius: 2,
                          offset: Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    tab.title,
                    style: const TextStyle(
                      fontFamily: 'Work Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w500, // FontWeight.w540 from design
                      height: 16 / 14, // Line height 16px from design
                      letterSpacing: -0.04, // Letter spacing -0.04em from design
                      color: Color(0xFF0C4123),
                    ).copyWith(
                      color: widget.activeTabColor.withOpacity(isSelected ? 1.0 : 0.45),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Desain tab dengan garis bawah (seperti pada screenshot)
  Widget _buildUnderlineTabBar() {
    return Row(
      children: widget.tabs.asMap().entries.map((entry) {
        final index = entry.key;
        final tab = entry.value;
        final isSelected = index == _currentIndex;

        return GestureDetector(
          onTap: () {
            _tabController.animateTo(index);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isSelected ? widget.activeTabColor : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: Text(
              tab.title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? widget.activeTabColor : const Color(0xFF6B7280),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
