import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

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
    return true;
  }

  /// Mendapatkan path file local untuk audio tertentu
  static Future<String> getLocalPath(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return "${directory.path}/audio/$fileName";
  }

  /// Cek apakah file sudah di-download
  static Future<bool> isDownloaded(String fileName) async {
    final path = await getLocalPath(fileName);
    return File(path).exists();
  }

  /// Download dari URL remote
  static Future<String?> downloadFromUrl(String url, String fileName) async {
    try {
      final filePath = await getLocalPath(fileName);
      final file = File(filePath);

      // Buat folder audio jika belum ada
      if (!await file.parent.exists()) {
        await file.parent.create(recursive: true);
      }

      debugPrint("DEBUG: Dimulai download $url");
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        debugPrint("DEBUG: Download SELESAI: $filePath");
        return filePath;
      } else {
        return "Gagal download: HTTP ${response.statusCode}";
      }
    } catch (e) {
      debugPrint("Download error: $e");
      return "Error: $e";
    }
  }

  /// Download dan simpan ke folder publik (Download)
  static Future<String?> saveToPublic(String url, String fileName) async {
    try {
      final hasPermission = await requestPermission();
      if (!hasPermission) return "Izin ditolak";

      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) return "Gagal download file";

      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) return "Folder tidak ditemukan";

      final filePath = "${directory.path}/$fileName";
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      
      return "Berhasil disimpan di: $fileName";
    } catch (e) {
      debugPrint("Save error: $e");
      return "Error: $e";
    }
  }

  /// Helper untuk memindahkan dari assets ke documents (jika ingin transisi bertahap)
  static Future<String?> saveAssetToLocal(String assetPath, String fileName) async {
    try {
      final byteData = await rootBundle.load(assetPath);
      final bytes = byteData.buffer.asUint8List();

      final filePath = await getLocalPath(fileName);
      final file = File(filePath);

      if (!await file.parent.exists()) {
        await file.parent.create(recursive: true);
      }

      await file.writeAsBytes(bytes);
      return filePath;
    } catch (e) {
      debugPrint("Copy error: $e");
      return null;
    }
  }
}
