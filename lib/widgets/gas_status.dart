import 'package:flutter/material.dart';
import 'package:keep_nigeria_clean/constants/level.dart';
import 'package:keep_nigeria_clean/theme/colors.dart';

class GasStatusWidget extends StatelessWidget {
  const GasStatusWidget({super.key, required this.level});

  final Level level;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final (color, text) = level == Level.high
        ? (AppColors.red, 'High')
        : level == Level.medium
        ? (AppColors.amber, 'Medium')
        : (AppColors.green, 'Low');

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 2.0,
      children: [
        Container(
          height: 4.0,
          width: 4.0,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        Text(text, style: theme.textTheme.labelSmall!.copyWith(color: color)),
      ],
    );
  }
}
