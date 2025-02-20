import 'package:dolphin_livin_demo/services/dolphin_logger.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  DolphinLogger log = DolphinLogger.instance;

  void listenForPermissions() async {
    final PermissionStatus status = await Permission.microphone.status;
    switch (status) {
      case PermissionStatus.denied:
        log.d("permission denied");
        requestForPermission();
        break;
      case PermissionStatus.granted:
        log.d("permission granted");
        break;
      case PermissionStatus.limited:
        log.d("permission limited");
        break;
      case PermissionStatus.permanentlyDenied:
        log.d("permission permanently denied");
        break;
      case PermissionStatus.restricted:
        log.d("permission restricted");
        break;
      default:
        log.d("permission default");
        break;
    }
  }

  Future<void> requestForPermission() async {
    await Permission.microphone.request();
  }
}
