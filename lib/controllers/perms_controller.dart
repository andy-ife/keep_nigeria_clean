import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermsController extends ChangeNotifier {
  PermissionStatus? currentPermStatus;

  PermsController() {
    Permission.location.status.then((i) {
      currentPermStatus = i;
      notifyListeners();
    });
  }

  Future<void> goToAppSettings() async {
    await openAppSettings();
  }

  Future<void> requestPerms() async {
    currentPermStatus = await Permission.location.request();
    notifyListeners();
  }

  Future<bool> hasPerms() async {
    return await Permission.location.status.isGranted;
  }
}
