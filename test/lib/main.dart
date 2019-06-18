// ignore_for_file: public_member_api_docs

/// @nodoc
library main;

import 'package:flutter_driver/driver_extension.dart';

import './test_app/test_app.dart';

void main() {
  enableFlutterDriverExtension();
  TestApp().run();
}
