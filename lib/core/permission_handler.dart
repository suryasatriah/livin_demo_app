import 'package:dolphin_livin_demo/services/dolphin_logger.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  static final LoggerService _log = LoggerService.instance;


  static Future<void> listenForPermissionMicrophone() async {
    await listenForPermission(Permission.microphone);
  }

  static Future<void> listenForPermission(Permission permission) async {
    final PermissionStatus status = await permission.status;
    switch (status) {
      case PermissionStatus.denied:
        _log.d("permission denied");
        _requestForPermission(permission);
        break;
      case PermissionStatus.granted:
        _log.d("permission granted");
        break;
      case PermissionStatus.limited:
        _log.d("permission limited");
        break;
      case PermissionStatus.permanentlyDenied:
        _log.d("permission permanently denied");
        break;
      case PermissionStatus.restricted:
        _log.d("permission restricted");
        break;
      default:
        _log.d("permission default");
        break;
    }
  }

  static Future<void> _requestForPermission(Permission permission) async {
    await permission.request();
  }
}
