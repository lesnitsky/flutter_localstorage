import 'dart:async';

import 'package:flutter/foundation.dart' show ValueNotifier;
import 'package:universal_html/html.dart' as html;

/// Creates instance of a local storage. Key is used as a filename
class LocalStorage {
  static final Map<String, LocalStorage> _cache = new Map();
  html.Storage get _storage => html.window.localStorage;

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
    onError = new ValueNotifier(null);

    ready = new Future<bool>(() async {
      await this._init();
      return true;
    });
  }

  Future<void> _init() async {
    try {
      // print(_storage.entries);
    } on Error catch (err) {
      onError.value = err;
    }
  }

  /// Returns a value from storage by key
  dynamic getItem(String key) {
    return _storage.entries.firstWhere((a) => a.key == key, orElse: () => null);
  }

  /// Saves item by key to a storage. Value should be json encodable (`json.encode()` is called under the hood).
  Future<void> setItem(String key, value) async {
    // _storage.update(key, (old) => value, ifAbsent: () => value);
    _storage.remove(key);
    _storage.putIfAbsent(key, () => value);
    return;
  }

  /// Removes item from storage by key
  Future<void> deleteItem(String key) async {
    _storage.remove(key);
    return;
  }

  /// Removes all items from localstorage
  Future<void> clear() {
    _storage.clear();
    return null;
  }
}
