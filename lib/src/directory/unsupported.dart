import 'dart:async';

import '../impl.dart';

class DirUtils implements LocalStorageImpl {
  DirUtils(this.fileName, [this.path]);

  final String path, fileName;

  StreamController<Map<String, dynamic>> storage =
      StreamController<Map<String, dynamic>>();

  @override
  Future clear() {
    throw 'Platform Not Supported';
  }

  @override
  void dispose() {
    throw 'Platform Not Supported';
  }

  @override
  Future<bool> exists() {
    throw 'Platform Not Supported';
  }

  @override
  Future flush() {
    throw 'Platform Not Supported';
  }

  @override
  dynamic getItem(String key) {
    throw 'Platform Not Supported';
  }

  @override
  Future init([Map<String, dynamic> initialData]) {
    throw 'Platform Not Supported';
  }

  @override
  Future remove(String key) {
    throw 'Platform Not Supported';
  }

  @override
  Future setItem(String key, value) {
    throw 'Platform Not Supported';
  }

  @override
  Stream<Map<String, dynamic>> get stream => storage.stream;
}
