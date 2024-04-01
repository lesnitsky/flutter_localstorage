/// LocalStorage for Flutter.
///
/// ```dart
/// import 'package:localstorage/localstorage.dart';
///
/// void main() {
///   WidgetsFlutterBinding.ensureInitialized();
///
///   localStorage.setItem('key', 'value');
///
///   // Will print "value" after app reload as well.
///   print(localStorage.getItem('key'));
/// }
/// ```
abstract interface class LocalStorage {
  /// The number of key/value pairs in the storage.
  int get length;

  /// Returns the name of the nth key in the storage.
  String? key(int index);

  /// Returns the current value associated with the given key.
  String? getItem(String key);

  /// Removes the key/value pair with the given key from the storage.
  void removeItem(String key);

  /// Sets value for the given key.
  void setItem(String key, String value);

  /// Clears all key/value pairs in the storage.
  void clear();
}
