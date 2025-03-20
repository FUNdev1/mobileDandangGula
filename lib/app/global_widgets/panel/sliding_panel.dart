import 'package:flutter/material.dart';

class SlidingPanel extends StatefulWidget {
  final Widget child;
  final bool isOpen;
  final double width;
  final Function? onClose;

  const SlidingPanel({
    super.key,
    required this.child,
    required this.isOpen,
    this.width = 497,
    this.onClose,
  });

  @override
  State<SlidingPanel> createState() => _SlidingPanelState();
}

class _SlidingPanelState extends State<SlidingPanel> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.isOpen) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(SlidingPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOpen != oldWidget.isOpen) {
      if (widget.isOpen) {
        _controller.forward();
      } else {
        _controller.reverse().then((_) {
          if (widget.onClose != null) {
            widget.onClose!();
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            // Semi-transparent background
            if (_controller.value > 0)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    if (widget.isOpen && widget.onClose != null) {
                      widget.onClose!();
                    }
                  },
                  child: Container(
                    color: Colors.black.withOpacity(0.2 * _controller.value),
                  ),
                ),
              ),

            // Sliding panel
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: widget.width,
              child: SlideTransition(
                position: _offsetAnimation,
                child: widget.child,
              ),
            ),
          ],
        );
      },
    );
  }
}
