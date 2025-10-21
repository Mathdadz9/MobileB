import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> requestLocationPermission() async {
    final status = await Permission.locationWhenInUse.status;
    if (status.isGranted) return true;
    final result = await Permission.locationWhenInUse.request();
    return result.isGranted;
  }

  static Future<bool> requestBackgroundLocationPermission() async {
    final status = await Permission.locationAlways.status;
    if (status.isGranted) return true;
    final result = await Permission.locationAlways.request();
    return result.isGranted;
  }
}