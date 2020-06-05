import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart' show ValueNotifier, VoidCallback;

import 'src/directory/directory.dart';

/// Creates instance of a local storage. Key is used as a filename
class LocalStorage {
  Stream<Map<String, dynamic>> get stream => _dir.stream;
  Map<String, dynamic> _initialData;
  static final Map<String, LocalStorage> _cache = new Map();
  final VoidCallback onInitError;

  DirUtils _dir;

  /// [ValueNotifier] which notifies about errors during storage initialization
  ValueNotifier<Error> onError;

  /// A future indicating if localstorage instance is ready for read/write operations
  Future<bool> ready;

  /// Prevents the file from being accessed more than once
  Future<void> _lock;

  /// [key] is used as a filename
  /// Optional [path] is used as a directory. Defaults to application document directory
  factory LocalStorage(String key,
      {String path,
      Map<String, dynamic> initialData,
      VoidCallback onInitError,
      bool debugMode}) {
    if (_cache.containsKey(key)) {
      return _cache[key];
    } else {
      final instance = LocalStorage._internal(
          key, path, initialData, onInitError, debugMode);
      _cache[key] = instance;

      return instance;
    }
  }

  void dispose() {
    _dir?.dispose();
  }

  LocalStorage._internal(String key,
      [String path,
      Map<String, dynamic> initialData,
      this.onInitError,
      bool debugMode]) {
    _dir = DirUtils(key, path, debugMode);
    _initialData = initialData;
    onError = new ValueNotifier(null);

    ready = new Future<bool>(() async {
      this._init();
      return true;
    });
  }

  Future<void> _init() async {
    try {
      var initOK = await _dir.init(_initialData);
      if (!initOK && onInitError != null) {
        onInitError();
      }
    } on Error catch (err) {
      onError.value = err;
    }
  }

  /// Returns a value from storage by key
  dynamic getItem(String key) {
    try {
      return _dir.getItem(key);
    } catch (err) {
      onError.value = err;
      return null;
    }
  }

  /// Saves item by [key] to a storage. Value should be json encodable (`json.encode()` is called under the hood).
  /// After item was set to storage, consecutive [getItem] will return `json` representation of this item
  /// if [toEncodable] is provided, it is called before setting item to storage
  /// otherwise `value.toJson()` is called
  Future<void> setItem(
    String key,
    value, [
    Object toEncodable(Object nonEncodable),
  ]) async {
    try {
      final _encoded =
          json.encode(toEncodable != null ? toEncodable(value) : value);
      await _dir.setItem(key, json.decode(_encoded));

      return _attemptFlush();
    } catch (err) {
      onError.value = err;
    }
  }

  /// Removes item from storage by key
  Future<void> deleteItem(String key) async {
    await _dir.remove(key);
    return _attemptFlush();
  }

  /// Removes all items from localstorage
  Future<void> clear() async {
    await _dir.clear();
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
    try {
      await _dir.flush();
    } catch (e) {
      onError.value = e;
      rethrow;
    }
    return;
  }
}
