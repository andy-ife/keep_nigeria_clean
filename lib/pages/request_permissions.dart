import 'package:flutter/material.dart';
import 'package:keep_nigeria_clean/controllers/perms_controller.dart';
import 'package:keep_nigeria_clean/pages/home/home.dart';
import 'package:keep_nigeria_clean/theme/styles.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class RequestPermissionsScreen extends StatefulWidget {
  const RequestPermissionsScreen({super.key});

  @override
  State<RequestPermissionsScreen> createState() =>
      _RequestPermissionsScreenState();
}

class _RequestPermissionsScreenState extends State<RequestPermissionsScreen>
    with WidgetsBindingObserver {
  late PermsController _permsController;

  @override
  void initState() {
    super.initState();

    _permsController = Provider.of<PermsController>(context, listen: false);
    _permsController.addListener(_permsListener);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      _permsController.hasPerms().then((doesHave) {
        if (doesHave && mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => HomeScreen()),
            (route) => false,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _permsController.removeListener(_permsListener);
    super.dispose();
  }

  void _permsListener() async {
    if (await _permsController.hasPerms() && mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => HomeScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<PermsController>();
    final permStatus = controller.currentPermStatus!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: theme.colorScheme.surfaceBright,
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.fromLTRB(16.0, 80.0, 16.0, 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Image.asset('assets/logo.png', width: 100.0, height: 100.0),
                SizedBox(height: 8.0),
                Text(
                  'Location Permission Needed',
                  style: theme.textTheme.titleLarge,
                ),
                SizedBox(height: 16.0),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text:
                            'To show nearby smart bins and allow you to report or interact with them, this app needs access to your ',
                        style: theme.textTheme.bodyLarge,
                      ),
                      TextSpan(
                        text: 'precise location.\n\n',
                        style: theme.textTheme.titleMedium,
                      ),

                      if (permStatus.isPermanentlyDenied)
                        TextSpan(
                          text:
                              'It looks like you\'ve permanently denied this permission. Please enable it in the ',
                          style: theme.textTheme.bodyLarge,
                        ),

                      if (permStatus.isPermanentlyDenied)
                        TextSpan(
                          text: 'app settings ',
                          style: theme.textTheme.titleMedium,
                        ),

                      if (permStatus.isPermanentlyDenied)
                        TextSpan(
                          text: 'to continue.',
                          style: theme.textTheme.bodyLarge,
                        ),
                    ],
                  ),
                ),
              ],
            ),

            permStatus.isPermanentlyDenied
                ? SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () async {
                        await controller.goToAppSettings();
                      },
                      style: AppButtonStyles.filled,
                      child: Text('Go to app settings'),
                    ),
                  )
                : SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () async {
                        await controller.requestPerms();
                      },
                      style: AppButtonStyles.filled,
                      child: Text('Grant location access'),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
