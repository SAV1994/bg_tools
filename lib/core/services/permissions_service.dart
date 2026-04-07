// services/permission_service.dart
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

// Сервис проверки и выдачи разрешений приложению
class PermissionService {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  // Получение версии Android
  static Future<int> getAndroidVersion() async {
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      return androidInfo.version.sdkInt;
    }
    return 0;
  }

  // Запрос разрешений
  static Future<bool> requestWritePermission() async {
    if (Platform.isIOS) return true;

    final androidVersion = await getAndroidVersion();

    // Для Android 13+ (API 33+)
    if (androidVersion >= 33) {
      final status = await Permission.photos.request();
      return status.isGranted;
    }
    // Для Android 11-12 (API 30-32)
    else if (androidVersion >= 30) {
      final status = await Permission.manageExternalStorage.request();
      if (status.isGranted) return true;

      // Если отказано, открываем настройки
      if (status.isPermanentlyDenied) {
        await openAppSettings();
      }
      return false;
    }
    // Для Android 10 и ниже (API 29-)
    else {
      final status = await Permission.storage.request();
      return status.isGranted;
    }
  }

  // Проверка наличия разрешений
  static Future<bool> hasWritePermission() async {
    if (Platform.isIOS) return true;

    final androidVersion = await getAndroidVersion();

    if (androidVersion >= 33) {
      return await Permission.photos.isGranted;
    } else if (androidVersion >= 30) {
      return await Permission.manageExternalStorage.isGranted;
    } else {
      return await Permission.storage.isGranted;
    }
  }
}
