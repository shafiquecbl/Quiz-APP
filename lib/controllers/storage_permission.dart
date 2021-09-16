import 'package:permission_handler/permission_handler.dart';

class StoragePermission {
  PermissionStatus? result;
  requestStoragePermission() async {
    if (!await Permission.storage.isGranted) {
      result = await Permission.storage.request();
      if (result!.isGranted) {
        print("Permission Granted");
      } else {
        result = await Permission.storage.request();
      }
    }
  }
}
