import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Integration Test App', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver ??= await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        await driver.close();
      }
    });

    test('run assert test', () async {
      await driver.tap(find.byValueKey('assertBtn'));

      bool success = false;

      final txtFinder = find.byValueKey('assertTxt');

      for (;;) {
        final txt = await driver.getText(txtFinder);

        if (txt.contains('success')) {
          success = true;
          break;
        }

        if (txt != '' && !txt.contains('running')) {
          success = false;
          break;
        }

        await Future<void>.delayed(Duration(milliseconds: 100));
      }

      expect(success, true);
    });

    test('run throughput test', () async {
      await driver.tap(find.byValueKey('tputBtn'));

      bool success = false;

      final txtFinder = find.byValueKey('tputTxt');

      for (;;) {
        final txt = await driver.getText(txtFinder);

        if (txt.contains('success')) {
          success = true;
          break;
        }

        if (txt != '' && !txt.contains('running')) {
          success = false;
          break;
        }

        await Future<void>.delayed(Duration(milliseconds: 100));
      }

      expect(success, true);
    }, timeout: Timeout(Duration(minutes: 1)));
  }, timeout: Timeout(Duration(minutes: 1)));
}
