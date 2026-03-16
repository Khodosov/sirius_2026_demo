import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LocalStorageManager {
  static const _fileName = 'demo.txt';

  Future<String> get _documentsPath async {
    final dir = await getApplicationDocumentsDirectory();
    print('[LocalStorage] Documents directory: ${dir.path}');
    return dir.path;
  }

  Future<String> get _tempPath async {
    final dir = await getTemporaryDirectory();
    print('[LocalStorage] Temp directory: ${dir.path}');
    return dir.path;
  }

  Future<void> saveToDocuments(String content) async {
    final path = await _documentsPath;
    final file = File('$path/$_fileName');
    await file.writeAsString(content);
    print('[LocalStorage] Saved to Documents: $path/$_fileName');
  }

  Future<void> saveToTemp(String content) async {
    final path = await _tempPath;
    final file = File('$path/$_fileName');
    await file.writeAsString(content);
    print('[LocalStorage] Saved to Temp: $path/$_fileName');
  }

  Future<String?> readFromDocuments() async {
    final path = await _documentsPath;
    final file = File('$path/$_fileName');
    if (await file.exists()) {
      return file.readAsString();
    }
    return null;
  }

  Future<String?> readFromTemp() async {
    final path = await _tempPath;
    final file = File('$path/$_fileName');
    if (await file.exists()) {
      return file.readAsString();
    }
    return null;
  }

  Future<String> getDocumentsFilePath() async {
    final path = await _documentsPath;
    return '$path/$_fileName';
  }

  Future<String> getTempFilePath() async {
    final path = await _tempPath;
    return '$path/$_fileName';
  }
}
