import 'dart:async';

abstract class LocalStorageImpl {
  LocalStorageImpl(this.fileName, [this.path]);

  final String fileName;
  final String? path;

  Stream<Map<String, dynamic>> get stream;

  void dispose();

  Future<void> init([Map<String, dynamic> initialData]);

  Future<int> getFileSize();

  Future<void> setItem(String key, dynamic value);

  dynamic getItem(String key);

  Future<bool> exists();

  Future<void> clear();

  Future<void> remove(String key);

  Future<void> flush();
}
