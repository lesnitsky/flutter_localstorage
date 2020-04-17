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
  Future<void> clear() async {
    localStorage.removeItem(fileName);
    storage.add(null);
    _data.clear();
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
  Future<void> flush() {
    return _writeToStorage(_data);
  }

  @override
  dynamic getItem(String key) {
    return _data[key];
  }

  @override
  Future<void> init([Map<String, dynamic> initialData]) async {
    _data = initialData ?? {};
    if (await exists()) {
      await _readFromStorage();
    } else {
      await _writeToStorage(_data);
    }
    return null;
  }

  @override
  Future<void> remove(String key) {
    _data.remove(key);
    return _writeToStorage(_data);
  }

  @override
  Future<void> setItem(String key, value) {
    _data[key] = value;
    return _writeToStorage(_data);
  }

  @override
  Stream<Map<String, dynamic>> get stream => storage.stream;

  Future<void> _writeToStorage(Map<String, dynamic> data) async {
    _data = data;
    storage.add(data);
    localStorage.update(
      fileName,
      (val) => json.encode(_data),
      ifAbsent: () => json.encode(_data),
    );
  }

  Future<void> _readFromStorage() async {
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
