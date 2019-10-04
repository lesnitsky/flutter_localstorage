import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;

import '../impl.dart';

class DirUtils implements LocalStorageImpl {
  final String path, fileName;

  DirUtils(this.fileName, [this.path]);
  html.Storage get localStorage => html.window.localStorage;
  Map<String, dynamic> _data = Map();

  StreamController<Map<String, dynamic>> storage =
      StreamController<Map<String, dynamic>>();

  @override
  Future clear() {
    localStorage.clear();
    storage.add(null);
    return null;
  }

  @override
  void dispose() {
    storage.close();
  }

  @override
  Future<bool> exists() async {
    return localStorage != null && localStorage.containsKey(fileName);
  }

  @override
  Future flush() {
    return _writeToStorage(_data);
  }

  @override
  dynamic getItem(String key) {
    return _data[key];
  }

  @override
  Future init([Map<String, dynamic> initialData]) async {
    _data = initialData ?? {};
    if (await exists()) {
      await _readFromStorage();
    } else {
      await _writeToStorage(_data);
    }
    return null;
  }

  @override
  Future remove(String key) {
    _data.remove(key);
    return _writeToStorage(_data);
  }

  @override
  Future setItem(String key, value) {
    _data[key] = value;
    return _writeToStorage(_data);
  }

  @override
  Stream<Map<String, dynamic>> get stream => storage.stream;

  Future _writeToStorage(Map<String, dynamic> data) async {
    _data = data;
    storage.add(data);
    localStorage.update(
      fileName,
      (val) => json.encode(_data),
      ifAbsent: () => json.encode(_data),
    );
  }

  Future _readFromStorage() async {
    final data = localStorage.entries.firstWhere(
      (i) => i.key == fileName,
      orElse: () => null,
    );
    if (data != null) {
      _data = json.decode(data.value) as Map<String, dynamic>;
      storage.add(_data);
    } else {
      await _writeToStorage({});
    }
  }
}
