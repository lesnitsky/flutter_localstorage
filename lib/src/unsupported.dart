import 'package:flutter/material.dart';

/// Creates instance of a local storage. Key is used as a filename
class LocalStorage {
  /// [ValueNotifier] which notifies about errors during storage initialization
  ValueNotifier<Error> onError;

  /// A future indicating if localstorage intance is ready for read/write operations
  Future<bool> ready;

  /// [key] is used as a filename
  /// Optional [path] is used as a directory. Defaluts to application document directory
  factory LocalStorage(String key, [String path]) {
    return LocalStorage(key, path);
  }

  /// Returns a value from storage by key
  dynamic getItem(String key) {
    throw 'Platform Not Supported';
  }

  /// Saves item by key to a storage. Value should be json encodable (`json.encode()` is called under the hood).
  Future<void> setItem(String key, value) async {
    throw 'Platform Not Supported';
  }

  /// Removes item from storage by key
  Future<void> deleteItem(String key) async {
    throw 'Platform Not Supported';
  }

  /// Removes all items from localstorage
  Future<void> clear() {
    throw 'Platform Not Supported';
  }

  Future<void> _attemptFlush() async {
    throw 'Platform Not Supported';
  }
}
