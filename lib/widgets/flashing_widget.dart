import 'package:flutter/material.dart';

class FlashingWidget extends StatefulWidget {
  final Widget child;
  final bool showFlashOnChangeOnly;

  const FlashingWidget({
    super.key,
    required this.child,
    this.showFlashOnChangeOnly = false,
  });

  @override
  State<FlashingWidget> createState() => _FlashingWidgetState();
}

class _FlashingWidgetState extends State<FlashingWidget> {
  Color _color = Colors.transparent;

  @override
  void didUpdateWidget(covariant FlashingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      if ((oldWidget.child is Text && widget.child is Text) &&
          (oldWidget.child as Text).data == (widget.child as Text).data &&
          widget.showFlashOnChangeOnly) {
        return;
      }
      _flash();
    }
  }

  void _flash() async {
    setState(() => _color = Colors.green.withOpacity(0.4));
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() => _color = Colors.transparent);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      key: ValueKey(widget.child),
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: widget.child,
    );
  }
}
