import 'package:flutter/material.dart';
import 'package:keep_nigeria_clean/constants/mapbox.dart';
import 'package:keep_nigeria_clean/controllers/map_controller.dart';
import 'package:keep_nigeria_clean/controllers/perms_controller.dart';
import 'package:keep_nigeria_clean/theme/theme.dart';
import 'package:keep_nigeria_clean/app.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:keep_nigeria_clean/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  MapboxOptions.setAccessToken(MapboxConstants.accessToken);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PermsController()),
        ChangeNotifierProvider(create: (_) => MapController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Keep Nigeria Clean',
      theme: AppTheme.light,
      themeMode: ThemeMode.light,
      home: KNCApp(),
    );
  }
}
