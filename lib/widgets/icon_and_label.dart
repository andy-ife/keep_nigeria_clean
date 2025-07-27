import 'package:flutter/material.dart';

class IconAndLabel extends StatelessWidget {
  const IconAndLabel({
    required this.icon,
    required this.label,
    this.spacing = 4.0,
    this.isHorizontal = true,
    super.key,
  });

  final Widget icon;
  final Widget label;
  final double spacing;
  final bool isHorizontal;

  @override
  Widget build(BuildContext context) {
    return isHorizontal
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              SizedBox(width: spacing),
              label,
            ],
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              SizedBox(width: spacing),
              label,
            ],
          );
  }
}
