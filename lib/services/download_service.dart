import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class DownloadService {
  static Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      
      if (androidInfo.version.sdkInt >= 33) {
        final status = await Permission.audio.request();
        return status.isGranted;
      } else {
        final status = await Permission.storage.request();
        return status.isGranted;
      }
    }
    return true; // iOS handles this differently or might not need it for basic saving
  }

  static Future<String?> downloadAudio(String assetPath, String fileName) async {
    try {
      final hasPermission = await requestPermission();
      if (!hasPermission) return "Permission Denied";

      // Load asset
      final byteData = await rootBundle.load(assetPath);
      final bytes = byteData.buffer.asUint8List();

      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) return "Directory not found";

      final filePath = "${directory.path}/$fileName";
      final file = File(filePath);
      await file.writeAsBytes(bytes);
      
      return "Saved to: $filePath";
    } catch (e) {
      debugPrint("Download error: $e");
      return "Error: $e";
    }
  }
}
