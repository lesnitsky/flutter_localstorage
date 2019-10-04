import 'dart:async';
import 'dart:html' as html;

import '../impl.dart';

class DirUtils implements LocalStorageImpl {
  final String path, fileName;

  DirUtils(this.fileName, [this.path]);
  html.Storage get _storage => html.window.localStorage;

  StreamController<Map<String, dynamic>> storage =
      StreamController<Map<String, dynamic>>();

  @override
  Future clear() {
    // TODO: implement clear
    return null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  Future<bool> exists() {
    // TODO: implement exists
    return null;
  }

  @override
  Future flush() {
    // TODO: implement flush
    return null;
  }

  @override
  dynamic getItem(String key) {
    // TODO: implement getItem
    return null;
  }

  @override
  Future init([Map<String, dynamic> initialData]) {
    // TODO: implement init
    return null;
  }

  @override
  Future remove(String key) {
    // TODO: implement remove
    return null;
  }

  @override
  Future setItem(String key, value) {
    // TODO: implement setItem
    return null;
  }

  @override
  // TODO: implement stream
  Stream<Map<String, dynamic>> get stream => storage.stream;
}
