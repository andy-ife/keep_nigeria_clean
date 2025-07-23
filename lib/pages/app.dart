import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keep_nigeria_clean/controllers/perms_controller.dart';
import 'package:keep_nigeria_clean/pages/home/home.dart';
import 'package:keep_nigeria_clean/pages/request_permissions.dart';
import 'package:keep_nigeria_clean/theme/colors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class KNCApp extends StatelessWidget {
  const KNCApp({super.key});

  @override
  Widget build(BuildContext context) {
    // init
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    final theme = Theme.of(context);
    final state = context.watch<PermsController>();

    if (state.currentPermStatus == null) {
      return Container(color: theme.colorScheme.surfaceBright);
    }

    return state.currentPermStatus!.isGranted
        ? HomeScreen()
        : RequestPermissionsScreen();
  }
}
