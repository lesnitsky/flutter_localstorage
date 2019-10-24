import 'dart:async';

import 'package:localstorage/src/errors.dart';

import '../impl.dart';

class DirUtils implements LocalStorageImpl {
  DirUtils(this.fileName, [this.path]);

  final String path, fileName;

  StreamController<Map<String, dynamic>> storage =
      StreamController<Map<String, dynamic>>();

  @override
  Future clear() {
    throw PlatformNotSupportedError();
  }

  @override
  void dispose() {
    throw PlatformNotSupportedError();
  }

  @override
  Future<bool> exists() {
    throw PlatformNotSupportedError();
  }

  @override
  Future flush() {
    throw PlatformNotSupportedError();
  }

  @override
  dynamic getItem(String key) {
    throw PlatformNotSupportedError();
  }

  @override
  Future init([Map<String, dynamic> initialData]) {
    throw PlatformNotSupportedError();
  }

  @override
  Future remove(String key) {
    throw PlatformNotSupportedError();
  }

  @override
  Future setItem(String key, value) {
    throw PlatformNotSupportedError();
  }

  @override
  Stream<Map<String, dynamic>> get stream => storage.stream;
}
