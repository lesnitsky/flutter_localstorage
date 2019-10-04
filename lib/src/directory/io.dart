import 'dart:async';
import 'dart:convert';

import 'dart:io';

import 'package:path_provider/path_provider.dart';

class DirUtils {
  final String path, fileName;

  DirUtils(this.fileName, [this.path]);

  Future<String> getPath() async {
    final dir = await _getDocumentDir();
    return dir.path;
  }

  Future writeFile(Map<String, dynamic> data) async {
    try {
      File _file = await _getFile();
      _file.writeAsStringSync(json.encode(data));
    } catch (e) {
      throw e;
    }
  }

  Future<Map<String, dynamic>> readFile() async {
    File _file = await _getFile();

    try {
      final content = await _file.readAsString();
      try {
        Map<String, dynamic> _data = json.decode(content);
        return _data;
      } catch (err) {
        _file.writeAsStringSync('{}');
        throw err;
      }
    } catch (e) {
      throw e;
    }
  }

  Future<bool> fileExists() async {
    File _file = await _getFile();
    return _file.existsSync();
  }

  Future<File> _getFile() async {
    final path = (await getPath());
    final _file = File('$path/$fileName.json');
    return _file;
  }

  Future<Directory> _getDocumentDir() async {
    if (Platform.isMacOS || Platform.isLinux) {
      return Directory('${Platform.environment['HOME']}/.config');
    } else if (Platform.isWindows) {
      return Directory('${Platform.environment['UserProfile']}\\.config');
    }
    return await getApplicationDocumentsDirectory();
  }
}
