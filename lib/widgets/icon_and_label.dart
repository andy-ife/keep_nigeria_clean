import 'package:flutter/material.dart';

class IconAndLabel extends StatelessWidget {
  const IconAndLabel({
    required this.icon,
    required this.label,
    this.spacing = 4.0,
    this.isHorizontal = true,
    this.align = CrossAxisAlignment.center,
    super.key,
  });

  final Widget icon;
  final Widget label;
  final double spacing;
  final bool isHorizontal;
  final CrossAxisAlignment align;

  @override
  Widget build(BuildContext context) {
    return isHorizontal
        ? Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              icon,
              SizedBox(width: spacing),
              label,
            ],
          )
        : Column(
            crossAxisAlignment: align,
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              SizedBox(width: spacing),
              label,
            ],
          );
  }
}
