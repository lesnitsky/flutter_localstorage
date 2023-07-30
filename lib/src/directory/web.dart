import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;

import 'package:localstorage/src/errors.dart';

import '../impl.dart';

class DirUtils implements LocalStorageImpl {
  final String fileName;
  final String? path;

  DirUtils(this.fileName, [this.path]);
  html.Storage get localStorage => html.window.localStorage;
  Map<String, dynamic> _data = Map();

  StreamController<Map<String, dynamic>> storage = StreamController<Map<String, dynamic>>();

  @override
  Future<void> clear() async {
    localStorage.remove(fileName);
    // storage.add(null);
    _data.clear();
  }

  @override
  void dispose() {
    storage.close();
  }

  @override
  Future<bool> exists() async {
    return localStorage.containsKey(fileName);
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
  Future<int> getFileSize() async {
    throw PlatformNotSupportedError();
  }

  @override
  Future<void> init([Map<String, dynamic> initialData = const {}]) async {
    _data = initialData;
    if (await exists()) {
      await _readFromStorage();
    } else {
      await _writeToStorage(_data);
    }
    return null;
  }

  @override
  Future<void> remove(String key) async {
    _data.remove(key);
  }

  @override
  Future<void> setItem(String key, value) async {
    _data[key] = value;
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
    // .firstWhere() is really a pain in dart 2.0
    MapEntry<String, String>? data;
    try {
      data = localStorage.entries.firstWhere((i) => i.key == fileName);
    } on StateError {
      data = null;
    }
    if (data != null) {
      _data = json.decode(data.value) as Map<String, dynamic>;
      storage.add(_data);
    } else {
      await _writeToStorage({});
    }
  }
}
