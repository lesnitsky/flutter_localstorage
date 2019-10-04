export 'src/unsupported.dart'
    if (dart.library.html) 'src/localstorage_web.dart'
    if (dart.library.io) 'src/localstorage_io.dart';
