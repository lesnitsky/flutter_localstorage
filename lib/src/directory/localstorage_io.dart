import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:localstorage/src/errors.dart';
import 'package:path_provider/path_provider.dart';

import '../impl.dart';

class DirUtils implements LocalStorageImpl {
  DirUtils(this.fileName, [this.path, this.debugMode]);

  final String path, fileName;
  final bool debugMode;

  Map<String, dynamic> _data = Map();

  @override
  Stream<Map<String, dynamic>> get stream => storage.stream;

  StreamController<Map<String, dynamic>> storage =
      StreamController<Map<String, dynamic>>();

  @override
  Future<void> clear() async {
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
  Future<void> flush() async {
    final serialized = json.encode(_data);
    File _file = await _getFile();
    await _file.writeAsString(serialized, flush: true);
    return;
  }

  @override
  dynamic getItem(String key) {
    return _data[key];
  }

  @override
  Future<bool> init([Map<String, dynamic> initialData]) async {
    _data = initialData ?? {};
    File _file = await _getFile();
    if (_file.existsSync()) {
      return await _readFile();
    } else {
      return await _writeFile(_data);
    }
  }

  @override
  Future<void> remove(String key) async {
    _data.remove(key);
    await _writeFile(_data);
  }

  @override
  Future<void> setItem(String key, dynamic value) async {
    _data[key] = value;
    await _writeFile(_data);
  }

  Future<bool> _writeFile(Map<String, dynamic> data) async {
    var isValidWrite = true;
    try {
      _data = data;
      storage.add(data);
      File _file = await _getFile();
      _file.writeAsString(
          ((data != null && data.isNotEmpty) ? json.encode(data) : data),
          flush: true);
    } catch (err) {
      isValidWrite = false;
    }
    return Future.value(isValidWrite);
  }

  Future<bool> _readFile() async {
    var validRead = true;
    File _file = await _getFile();
    try {
      final content = await _file.readAsString();
      _data = json.decode(content) as Map<String, dynamic>;
    } catch (err) {
      if (err is FormatException) {
        if (debugMode) {
          print('!!!!!~~~~~~recovery attempt)))))))((((((((~~~~~~~~');
        }
        _file.deleteSync();
        init(_data);
        validRead = false;
      }
    }
    storage.add(_data);
    return Future.value(validRead);
  }

  Future<File> _getFile() async {
    final dir = await _getDocumentDir();
    final _path = path ?? dir.path;
    final _file = File('$_path/$fileName');
    return _file;
  }

  Future<Directory> _getDocumentDir() async {
    try {
      Directory dir = await getApplicationDocumentsDirectory();
      if (debugMode) {
        print('!!!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${dir?.path ?? ''}');
      }
      return dir;
    } catch (err) {
      throw PlatformNotSupportedError();
    }
  }
}
