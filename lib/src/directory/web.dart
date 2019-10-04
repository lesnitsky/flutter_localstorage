import 'dart:async';
import '../cooky.dart' as cookie;

class DirUtils {
  final String path, fileName;

  DirUtils(this.fileName, [this.path]);

  Future writeFile(String data) async {
    cookie.set(fileName, data, path: path);
    return;
  }

  Future<String> readFile() async {
    return cookie.get(fileName);
  }

  Future<bool> fileExists() async {
    final data = cookie.get(fileName);
    return data != null;
  }
}
