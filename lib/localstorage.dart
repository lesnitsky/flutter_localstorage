import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

/// Creates instance of a local storage. Key is used as a filename
class LocalStorage {
  static final Map<String, LocalStorage> _cache = new Map();

  String _filename;
  File _file;
  Map<String, dynamic> _data;

  /// A future indicating if localstorage intance is ready for read/write operations
  Future<bool> ready;

  factory LocalStorage(String key) {
    if (_cache.containsKey(key)) {
      return _cache[key];
    } else {
      final instance = LocalStorage._internal(key);
      _cache[key] = instance;

      return instance;
    }
  }

  LocalStorage._internal(String key) {
    _filename = key;
    _data = new Map();

    ready = new Future<bool>(() async {
      await this._init();
      return true;
    });
  }

  _init() async {
    final documentDir = await getApplicationDocumentsDirectory();
    final path = documentDir.path;

    _file = File('$path/$_filename.json');

    await _file;

    var exists = _file.existsSync();

    if (exists) {
      final content = await _file.readAsString();
      _data = json.decode(content);
    } else {
      _file.writeAsStringSync('{}');
      return _init();
    }
  }

  /// Saves item by key to a storage. Value should be json encodable (`json.encode()` is called under the hood).
  setItem(String key, value) async {
    _data[key] = value;

    return _flush();
  }

  /// Removes item from storage by key
  deleteItem(String key) async {
    _data.remove(key);

    return _flush();
  }

  _flush() async {
    final serialized = json.encode(_data);
    await _file.writeAsString(serialized);
  }

  /// Returns a value from storage by key
  getItem(String key) {
    return _data[key];
  }
}
