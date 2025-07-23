import 'package:flutter/material.dart';

class IconAndLabel extends StatelessWidget {
  const IconAndLabel({
    required this.icon,
    required this.label,
    this.spacing = 4.0,
    super.key,
  });

  final Widget icon;
  final Widget label;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        SizedBox(width: spacing),
        label,
      ],
    );
  }
}
