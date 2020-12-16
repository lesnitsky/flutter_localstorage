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

  RandomAccessFile _file;

  @override
  Future<void> clear() async {
    _data.clear();
    storage.add(null);
  }

  @override
  void dispose() {
    storage.close();
    _file.close();
  }

  @override
  Future<bool> exists() async {
    return true;
  }

  @override
  Future<void> flush([dynamic data]) async {
    final serialized = json.encode(data ?? _data);
    _file = await _file.lock();
    _file = await _file.setPosition(0);
    _file = await _file.writeString(serialized);
    _file = await _file.truncate(serialized.length);
  }

  @override
  dynamic getItem(String key) {
    return _data[key];
  }

  @override
  Future<void> init([Map<String, dynamic> initialData]) async {
    _data = initialData ?? {};

    final f = await _getFile();
    final length = await f.length();

    if (length == 0) {
      return flush({});
    } else {
      await _readFile();
    }
  }

  @override
  Future<void> remove(String key) async {
    _data.remove(key);
  }

  @override
  Future<void> setItem(String key, dynamic value) async {
    _data[key] = value;
  }

  Future<void> _readFile() async {
    RandomAccessFile _file = await _getFile();
    final length = await _file.length();
    final buffer = await _file.read(length);
    final contentText = utf8.decode(buffer);

    _data = json.decode(contentText) as Map<String, dynamic>;
    storage.add(_data);
  }

  Future<RandomAccessFile> _getFile() async {
    if (_file != null) {
      return _file;
    }

    final _path = path ?? (await _getDocumentDir()).path;
    final file = File('$_path/$fileName');

    if (await file.exists()) {
      _file = await file.open(mode: FileMode.append);
      return _file;
    } else {
      await file.create();
      return await file.open(mode: FileMode.append);
    }
  }

  Future<Directory> _getDocumentDir() async {
    try {
      return await getApplicationDocumentsDirectory();
    } catch (err) {
      throw PlatformNotSupportedError();
    }
  }
}
