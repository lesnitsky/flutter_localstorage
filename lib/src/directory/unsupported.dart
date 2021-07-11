import 'dart:async';

import 'package:localstorage/src/errors.dart';

import '../impl.dart';

class DirUtils implements LocalStorageImpl {
  DirUtils(this.fileName, [this.path]);

  final String fileName;
  final String? path;

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
  Map<String, dynamic> getData() {
    throw PlatformNotSupportedError();
  }

  @override
  dynamic setData(dynamic jsonData) {
    throw PlatformNotSupportedError();
  }
  @override
  Future<void> init([Map<String, dynamic>? initialData]) {
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
