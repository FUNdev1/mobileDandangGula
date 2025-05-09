import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/utils/utils.dart';
import '../text/app_text.dart';
import 'app_text_field.dart';

class AppDropdownField extends StatefulWidget {
  final String? label;

  final String hint;
  final List items;
  final String selectedValue;
  final Function(String?) onChanged;
  final String valueKey;
  final String displayKey;
  final bool showAllOption;
  final bool isMandatory;
  final String? errorText;

  const AppDropdownField({
    super.key,
    this.label,
    required this.hint,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.valueKey = "id",
    this.displayKey = "role",
    this.showAllOption = true,
    this.isMandatory = false,
    this.errorText,
  });

  @override
  State<AppDropdownField> createState() => _AppDropdownFieldState();
}

class _AppDropdownFieldState extends State<AppDropdownField> {
  final LayerLink _layerLink = LayerLink();
  final TextEditingController _searchController = TextEditingController();
  OverlayEntry? _overlayEntry;
  bool _isDropdownOpen = false;
  String _searchText = '';

  List _displayItems = [];

  @override
  void initState() {
    super.initState();
    _updateDisplayItems();
  }

  @override
  void didUpdateWidget(AppDropdownField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items || oldWidget.showAllOption != widget.showAllOption) {
      _updateDisplayItems();
    }
  }

  void _updateDisplayItems() {
    _displayItems = _getItemsWithAllOption();
  }

  List _getItemsWithAllOption() {
    List allItems = List.from(widget.items);

    if (widget.showAllOption) {
      bool allOptionExists = allItems.any((item) => item[widget.valueKey] == "" && item[widget.displayKey] == widget.hint);

      if (!allOptionExists) {
        allItems.insert(0, {
          widget.valueKey: "",
          widget.displayKey: widget.hint,
        });
      }
    }

    return allItems;
  }

  List _getFilteredItems() {
    if (_searchText.isEmpty) {
      return _displayItems;
    }

    return _displayItems.where((item) => item[widget.displayKey].toString().toLowerCase().contains(_searchText.toLowerCase())).toList();
  }

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _removeOverlay();
    } else {
      _showOverlay();
    }

    setState(() {
      _isDropdownOpen = !_isDropdownOpen;
    });
  }

  void _showOverlay() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: renderBox.size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 5),
          child: Material(
            elevation: 0,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_displayItems.length > 3)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppTextField(
                        controller: _searchController,
                        hint: 'Search...',
                        prefixIcon: AppIcons.search,
                        onFocusChanged: (value) {
                          setState(() {
                            _searchText = value;
                            _updateOverlay();
                          });
                        },
                      ),
                    ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 200,
                    ),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      children: _getFilteredItems().map((item) {
                        final bool isSelected = item[widget.valueKey] == widget.selectedValue;

                        return InkWell(
                          onTap: () {
                            widget.onChanged(item[widget.valueKey]);
                            _searchText = '';
                            _searchController.clear();
                            _removeOverlay();
                            setState(() {
                              _isDropdownOpen = false;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            color: isSelected ? const Color(0xFFEEEEEE) : Colors.white,
                            child: AppText(
                              item[widget.displayKey] ?? "",
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _updateOverlay() {
    _overlayEntry?.markNeedsBuild();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  bool get _hasError => widget.isMandatory && widget.selectedValue.isEmpty && widget.errorText != null;

  @override
  void dispose() {
    _removeOverlay();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedItem = _displayItems.firstWhere(
      (item) => item[widget.valueKey] == widget.selectedValue,
      orElse: () => {widget.valueKey: "", widget.displayKey: widget.hint},
    );

    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null) ...[
            Row(
              children: [
                Text(
                  widget.label!,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                if (widget.isMandatory)
                  const Text(
                    ' *',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
          ],
          GestureDetector(
            onTap: _toggleDropdown,
            child: Container(
              height: 40,
              // width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _hasError ? Colors.red : const Color(0xFFE0E0E0),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),

              child: Row(
                children: [
                  Expanded(
                    child: AppText(
                      widget.selectedValue.isEmpty ? widget.hint : selectedItem[widget.displayKey],
                      style: TextStyle(
                        color: widget.selectedValue.isEmpty ? const Color(0xFF9E9E9E) : Colors.black,
                      ),
                    ),
                  ),
                  SvgPicture.asset(
                    _isDropdownOpen ? AppIcons.caretUp : AppIcons.caretDown,
                    // color: const Color(0xFF9E9E9E),
                    height: 16,
                    width: 16,
                  )
                ],
              ),
            ),
          ),
          if (_hasError)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 4),
              child: Text(
                widget.errorText!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
