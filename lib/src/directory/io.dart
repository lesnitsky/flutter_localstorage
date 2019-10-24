import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:localstorage/src/errors.dart';
import 'package:path_provider/path_provider.dart';

import '../impl.dart';

class DirUtils implements LocalStorageImpl {
  DirUtils(this.fileName, [this.path]);

  final String path, fileName;

  Map<String, dynamic> _data = Map();

  @override
  Stream<Map<String, dynamic>> get stream => storage.stream;

  StreamController<Map<String, dynamic>> storage =
      StreamController<Map<String, dynamic>>();

  @override
  Future clear() async {
    File _file = await _getFile();
    _data.clear();
    storage.add(null);
    return _file.deleteSync();
  }

  @override
  void dispose() {
    storage.close();
  }

  @override
  Future<bool> exists() async {
    File _file = await _getFile();
    return _file.existsSync();
  }

  @override
  Future flush() async {
    final serialized = json.encode(_data);
    File _file = await _getFile();
    _file.writeAsStringSync(serialized);
    return;
  }

  @override
  dynamic getItem(String key) {
    return _data[key];
  }

  @override
  Future init([Map<String, dynamic> initialData]) async {
    _data = initialData ?? {};
    File _file = await _getFile();
    if (_file.existsSync()) {
      return _readFile();
    } else {
      return _writeFile(_data);
    }
  }

  @override
  Future remove(String key) async {
    await _writeFile(_data);
  }

  @override
  Future setItem(String key, dynamic value) async {
    _data[key] = value;
    await _writeFile(_data);
  }

  Future _writeFile(Map<String, dynamic> data) async {
    try {
      _data = data;
      storage.add(data);
      File _file = await _getFile();
      _file.writeAsStringSync(json.encode(data));
    } catch (e) {
      throw e;
    }
  }

  Future<void> _readFile() async {
    File _file = await _getFile();
    try {
      final content = _file.readAsStringSync();
      try {
        _data = json.decode(content) as Map<String, dynamic>;
        storage.add(_data);
      } catch (err) {
        throw err;
      }
    } catch (e) {
      throw e;
    }
  }

  Future<File> _getFile() async {
    final dir = await _getDocumentDir();
    final _path = path ?? dir.path;
    final _file = File('$_path/$fileName');
    return _file;
  }

  Future<Directory> _getDocumentDir() async {
    try {
      return await getApplicationDocumentsDirectory();
    } catch (err) {
      throw PlatformNotSupportedError();
    }
  }
}
