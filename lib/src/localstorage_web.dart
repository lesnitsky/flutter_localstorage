// ignore: avoid_web_libraries_in_flutter
import 'dart:html' show window;
import './interface.dart';

Future<LocalStorage> init() async {
  return LocalStorageImpl();
}

final class LocalStorageImpl implements LocalStorage {
  @override
  int get length => window.localStorage.length;

  @override
  void clear() => window.localStorage.clear();

  @override
  String? getItem(String key) => window.localStorage[key];

  @override
  String? key(int index) => window.localStorage.keys.elementAt(index);

  @override
  void removeItem(String key) => window.localStorage.remove(key);

  @override
  void setItem(String key, String value) {
    window.localStorage[key] = value;
  }
}
