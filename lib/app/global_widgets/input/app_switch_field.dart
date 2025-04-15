import 'package:flutter/material.dart';

class AppSwitch extends StatelessWidget {
  final bool value;
  final String activeText;
  final String inactiveText;
  final Function(bool) onChanged;

  const AppSwitch({
    Key? key,
    required this.value,
    required this.activeText,
    required this.inactiveText,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: const Color(0xFFF5F5F5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => onChanged(true),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: value ? const Color(0xFF1B9851) : Colors.transparent,
              ),
              child: Text(
                activeText,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: value ? Colors.white : const Color(0xFF9E9E9E),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => onChanged(false),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: !value ? const Color(0xFFFF3B30) : Colors.transparent,
              ),
              child: Text(
                inactiveText,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: !value ? Colors.white : const Color(0xFF9E9E9E),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}