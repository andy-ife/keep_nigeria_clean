import 'package:flutter/material.dart';
import 'package:keep_nigeria_clean/pages/splash.dart';
import 'package:keep_nigeria_clean/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.light,
      themeMode: ThemeMode.light,
      home: SplashScreen(),
    );
  }
}
