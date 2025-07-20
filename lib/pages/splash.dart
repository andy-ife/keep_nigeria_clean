import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: theme.colorScheme.surfaceBright,
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: EdgeInsetsGeometry.fromLTRB(32.0, 268.0, 32.0, 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Image.asset('assets/logo.png', width: 160.0, height: 160.0),
                  SizedBox(height: 20.0),
                  Text(
                    'Keep Nigeria Clean',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium,
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    'Building a cleaner future together',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: theme.colorScheme.onPrimaryFixed,
                    ),
                  ),
                ],
              ),

              Column(
                children: [
                  Text(
                    'Loading',
                    style: theme.textTheme.labelMedium!.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 12.0),
                  SizedBox(
                    width: 100.0,
                    child: LinearProgressIndicator(
                      minHeight: 4.0,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                ],
              ),

              Text(
                'Powered by AI and IoT for a sustainable Nigeria',
                textAlign: TextAlign.center,
                style: theme.textTheme.labelMedium!.copyWith(
                  fontWeight: FontWeight.normal,
                  color: theme.colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
