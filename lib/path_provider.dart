import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart' as pp;

final configDirectory = Directory('${Platform.environment['HOME']}/.config');

Future<Directory> _getTemporaryDirectory() => Future.value(configDirectory);
Future<Directory> _getApplicationSupportDirectory() =>
    Future.value(configDirectory);
Future<Directory> _getApplicationDocumentsDirectory() =>
    Future.value(configDirectory);
Future<Directory> _getExternalStorageDirectory() =>
    Future.value(configDirectory);

final _isDesktop = Platform.isFuchsia ||
    Platform.isMacOS ||
    Platform.isLinux ||
    Platform.isWindows;

final getTemporaryDirectory =
    _isDesktop ? _getTemporaryDirectory : pp.getTemporaryDirectory;
final getApplicationSupportDirectory = _isDesktop
    ? _getApplicationSupportDirectory
    : pp.getApplicationSupportDirectory;
final getApplicationDocumentsDirectory = _isDesktop
    ? _getApplicationDocumentsDirectory
    : pp.getApplicationDocumentsDirectory;
final getExternalStorageDirectory =
    _isDesktop ? _getExternalStorageDirectory : pp.getExternalStorageDirectory;
