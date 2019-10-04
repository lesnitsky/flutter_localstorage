import 'dart:async';

abstract class LocalStorageImpl {
  LocalStorageImpl(this.fileName, [this.path]);

  final String path, fileName;

  Stream<Map<String, dynamic>> get stream;

  void dispose();

  Future init([Map<String, dynamic> initialData]);

  Future setItem(String key, dynamic value);

  dynamic getItem(String key);

  Future<bool> exists();

  Future clear();

  Future remove(String key);

  Future flush();
}
