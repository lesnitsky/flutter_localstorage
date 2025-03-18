import './src/interface.dart';
import './src/localstorage_io.dart'
    if (dart.library.js_interop) './src/localstorage_web.dart';

export './src/interface.dart';

bool _initialized = false;
late LocalStorage _localStorage;

/// Initialize the [LocalStorage].
Future<void> initLocalStorage() async {
  if (_initialized) return;

  _localStorage = await init();
  _initialized = true;
}

/// Get the instance of [LocalStorage].
LocalStorage get localStorage {
  if (_initialized) return _localStorage;
  return _localStorage;
}
