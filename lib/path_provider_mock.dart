import 'dart:async';
import 'dart:io';

Future<Directory> getTemporaryDirectory() => Future.value(Directory(''));
Future<Directory> getApplicationSupportDirectory() =>
    Future.value(Directory(''));
Future<Directory> getApplicationDocumentsDirectory() =>
    Future.value(Directory(''));
Future<Directory> getExternalStorageDirectory() => Future.value(Directory(''));
