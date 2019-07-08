import 'dart:async';
import 'dart:io';

final configDirectory = Directory('${Platform.environment['HOME']}/.config');

Future<Directory> getTemporaryDirectory() => Future.value(configDirectory);
Future<Directory> getApplicationSupportDirectory() =>
    Future.value(configDirectory);
Future<Directory> getApplicationDocumentsDirectory() =>
    Future.value(configDirectory);
Future<Directory> getExternalStorageDirectory() =>
    Future.value(configDirectory);
