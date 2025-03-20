import 'package:flutter/material.dart';

class ToogleButton extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color inactiveColor;
  final Color knobColor;

  const ToogleButton({
    Key? key,
    required this.value,
    required this.onChanged,
    this.activeColor = const Color(0xFF23C368),
    this.inactiveColor = const Color(0xFFF2F2F2),
    this.knobColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        width: 40,
        height: 20,
        decoration: BoxDecoration(
          color: value ? activeColor : inactiveColor,
          borderRadius: BorderRadius.circular(36.5),
          border: Border.all(
            color: value ? const Color(0xFF1B9851) : const Color(0xFFE5E5E5),
            width: 0.5,
          ),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              left: value ? 20 : 0,
              top: 0,
              child: Container(
                width: 20,
                height: 20,
                padding: const EdgeInsets.all(2),
                child: Container(
                  decoration: BoxDecoration(
                    color: knobColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF333333).withOpacity(0.3),
                        offset: const Offset(1, 1),
                        blurRadius: 2,
                        spreadRadius: -1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
