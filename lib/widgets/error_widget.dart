import 'package:flutter/material.dart';

/// A centered, stateless error view that shows an icon, a message and a retry button.
/// If [onRetry] is null, the retry button will be disabled.
class KNCErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final String retryLabel;
  final double iconSize;
  final EdgeInsetsGeometry padding;

  const KNCErrorWidget({
    super.key,
    this.message = 'Something went wrong',
    this.onRetry,
    this.retryLabel = 'Retry',
    this.iconSize = 64.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 24.0),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodyMedium;

    return Center(
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: iconSize,
              color: theme.colorScheme.error,
              semanticLabel: 'Error',
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center, style: textStyle),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(retryLabel),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(120, 44),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
