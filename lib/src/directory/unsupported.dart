import 'dart:async';

import 'package:localstorage/src/errors.dart';
import 'package:localstorage/localstorage.dart';

import '../impl.dart';

class DirUtils with DirUtilsProtocol implements LocalStorageImpl {
  DirUtils(this.fileName, [this.path, this.debugMode]);

  final String path, fileName;
  final bool debugMode;

  StreamController<Map<String, dynamic>> storage =
      StreamController<Map<String, dynamic>>();

  @override
  Future<void> clear() {
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
  Future<void> flush() {
    throw PlatformNotSupportedError();
  }

  @override
  dynamic getItem(String key) {
    throw PlatformNotSupportedError();
  }

  @override
  Future<bool> init([Map<String, dynamic> initialData]) {
    throw PlatformNotSupportedError();
  }

  @override
  Future<void> remove(String key) {
    throw PlatformNotSupportedError();
  }

  @override
  Future<void> setItem(String key, value) {
    throw PlatformNotSupportedError();
  }

  @override
  Stream<Map<String, dynamic>> get stream => storage.stream;
}
