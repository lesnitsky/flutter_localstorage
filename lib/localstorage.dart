import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart' show ValueNotifier;

import 'src/directory/directory.dart';

/// Creates instance of a local storage. Key is used as a filename
class LocalStorage {
  static final Map<String, LocalStorage> _cache = new Map();

  DirUtils _dir;
  Map<String, dynamic> _data;

  /// [ValueNotifier] which notifies about errors during storage initialization
  ValueNotifier<Error> onError;

  /// A future indicating if localstorage intance is ready for read/write operations
  Future<bool> ready;

  /// Prevents the file from being accessed more than once
  Future<void> _lock;

  /// [key] is used as a filename
  /// Optional [path] is used as a directory. Defaluts to application document directory
  factory LocalStorage(String key, [String path]) {
    if (_cache.containsKey(key)) {
      return _cache[key];
    } else {
      final instance = LocalStorage._internal(key, path);
      _cache[key] = instance;

      return instance;
    }
  }

  LocalStorage._internal(String key, [String path]) {
    _data = new Map();
    _dir = DirUtils(key, path);
    onError = new ValueNotifier(null);

    ready = new Future<bool>(() async {
      await this._init();
      return true;
    });
  }

  Future<void> _init() async {
    try {
      var exists = await _dir.fileExists();

      if (exists) {
        final content = await _dir.readFile();

        try {
          _data = json.decode(content);
        } catch (err) {
          onError.value = err;
          _data = {};
          await _dir.writeFile('{}');
        }
      } else {
        await _dir.writeFile('{}');
        return _init();
      }
    } on Error catch (err) {
      onError.value = err;
    }
  }

  /// Returns a value from storage by key
  dynamic getItem(String key) {
    return _data[key];
  }

  /// Saves item by key to a storage. Value should be json encodable (`json.encode()` is called under the hood).
  Future<void> setItem(String key, value) async {
    _data[key] = value;

    return _attemptFlush();
  }

  /// Removes item from storage by key
  Future<void> deleteItem(String key) async {
    _data.remove(key);

    return _attemptFlush();
  }

  /// Removes all items from localstorage
  Future<void> clear() {
    _data.clear();
    return _attemptFlush();
  }

  Future<void> _attemptFlush() async {
    if (_lock != null) {
      await _lock;
    }

    // Lock will complete when file has been written
    _lock = _flush();

    return _lock;
  }

  Future<void> _flush() async {
    final serialized = json.encode(_data);
    try {
      await _dir.writeFile(serialized);
    } catch (e) {
      rethrow;
    }
    return;
  }
}
