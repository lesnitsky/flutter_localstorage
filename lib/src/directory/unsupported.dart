import 'dart:async';

class DirUtils {
  final String path, fileName;

  DirUtils(this.fileName, [this.path]);

  Future<String> getPath() async {
    throw 'Platform Not Supported';
  }

  Future writeFile(String data) {
    throw 'Platform Not Supported';
  }

  Future<String> readFile() {
    throw 'Platform Not Supported';
  }

  Future<bool> fileExists() {
    throw 'Platform Not Supported';
  }
}
