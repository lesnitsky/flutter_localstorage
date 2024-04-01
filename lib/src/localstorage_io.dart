import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import './interface.dart';

const kStorageFileName = 'storage-61f76cb0-842b-4318-a644-e245f50a0b5a.json';

Future<LocalStorage> init() async {
  final dir = await getApplicationDocumentsDirectory();
  final storagePath = p.join(dir.path, kStorageFileName);

  final storageFile = File(storagePath);

  if (!storageFile.existsSync()) {
    storageFile.createSync();
  }

  try {
    final content = storageFile.readAsStringSync();
    final json = jsonDecode(content) as Map;
    return LocalStorageImpl(storageFile, json.cast<String, String>());
  } catch (e) {
    stderr.writeln('Error parsing local storage content');
    stderr.writeln(e);

    storageFile.writeAsStringSync('{}');
    return LocalStorageImpl(storageFile, <String, String>{});
  }
}

class LocalStorageImpl implements LocalStorage {
  final File _storageFile;
  final Map<String, String> _storage;

  LocalStorageImpl(this._storageFile, this._storage);

  void _save() {
    final content = jsonEncode(_storage);
    _storageFile.writeAsStringSync(content);
  }

  @override
  void clear() {
    _storage.clear();
    _save();
  }

  @override
  String? getItem(String key) {
    return _storage[key];
  }

  @override
  String? key(int index) {
    return _storage.keys.elementAt(index);
  }

  @override
  int get length => _storage.length;

  @override
  void removeItem(String key) {
    _storage.remove(key);
    _save();
  }

  @override
  void setItem(String key, String value) {
    _storage[key] = value;
    _save();
  }
}
