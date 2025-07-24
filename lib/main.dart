import 'package:flutter/material.dart';
import 'package:keep_nigeria_clean/constants/mapbox.dart';
import 'package:keep_nigeria_clean/controllers/perms_controller.dart';
import 'package:keep_nigeria_clean/theme/theme.dart';
import 'package:keep_nigeria_clean/app.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  MapboxOptions.setAccessToken(MapboxConstants.accessToken);

  runApp(
    ChangeNotifierProvider(
      create: (_) => PermsController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.light,
      themeMode: ThemeMode.light,
      home: KNCApp(),
    );
  }
}
