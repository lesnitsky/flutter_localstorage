import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart' show ValueNotifier;
import 'package:path_provider/path_provider.dart';

/// Creates instance of a local storage. Key is used as a filename
class LocalStorage {
  static final Map<String, LocalStorage> _cache = new Map();

  String _filename;
  File _file;
  String _path;
  Map<String, dynamic> _data;

  /// [ValueNotifier] which notifies about errors during storage initialization
  ValueNotifier<Error> onError;

  /// A future indicating if localstorage instance is ready for read/write operations
  Future<bool> ready;

  /// Prevents the file from being accessed more than once
  Future<void> _lock;

  /// [key] is used as a filename
  /// Optional [path] is used as a directory. Defaults to application document directory
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
    _filename = key;
    _data = new Map();
    _path = path;
    onError = new ValueNotifier(null);

    ready = new Future<bool>(() async {
      await this._init();
      return true;
    });
  }

  Future<Directory> _getDocumentDir() async {
    if (Platform.isMacOS || Platform.isLinux) {
      return Directory('${Platform.environment['HOME']}/.config');
    } else if (Platform.isWindows) {
      return Directory('${Platform.environment['UserProfile']}\\.config');
    }
    return await getApplicationDocumentsDirectory();
  }

  Future<void> _init() async {
    try {
      final path = _path ?? (await _getDocumentDir()).path;

      _file = File('$path/$_filename.json');

      var exists = _file.existsSync();

      if (exists) {
        final content = await _file.readAsString();

        try {
          _data = json.decode(content);
        } catch (err) {
          onError.value = err;
          _data = {};
          _file.writeAsStringSync('{}');
        }
      } else {
        _file.writeAsStringSync('{}');
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

  /// Saves item by [key] to a storage. Value should be json encodable (`json.encode()` is called under the hood).
  /// After item was set to storage, consecutive [getItem] will return `json` representation of this item
  /// if [toEncodable] is provided, it is called before setting item to storage
  /// otherwise `value.toJson()` is called
  Future<void> setItem(
    String key,
    value, [
    Object toEncodable(Object nonEncodable),
  ]) async {
    _data[key] = json.decode(
      json.encode(toEncodable != null ? toEncodable(value) : value),
    );

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
      await ready;
      await _file.writeAsString(serialized);
    } catch (e) {
      rethrow;
    }
    return;
  }
}
